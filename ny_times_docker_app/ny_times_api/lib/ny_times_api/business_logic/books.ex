defmodule NyTimesApi.BusinessLogic.Books do
  use GenServer

  alias NyTimesApi.BusinessLogic.ClientApi
  alias NyTimesApi.Db.Library
  alias NyTimesApi.Db.News

  # Structs

  defmodule Review do
    defstruct summary: "",
              author: "",
              book_title: ""
  end

  defmodule Book do
    defstruct title: "",
              genre: "",
              description: "",
              author: "",
              reviews: nil
  end

  defmodule Author do
    defstruct first_name: "",
              last_name: ""
  end

  defmodule State do
    defstruct genre: "",
              books: []
  end

  # API #

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def best(genre, number \\ 1, ordering \\ &>=/2) do
    GenServer.call(String.to_atom(genre), {:best, number, ordering})
  end

  def bottom(genre, number \\ 1) do
    GenServer.call(String.to_atom(genre), {:best, number, &<=/2})
  end

  # Callback #

  def init(name) do
    Process.send_after(self(), :set_state, 1_000)
    {:ok, %State{genre: name}}
  end

  def handle_call({:best, number, ordering}, _from, %State{books: books} = state) do
    case Enum.all?(books, fn %Book{reviews: reviews} -> !is_nil(reviews) end) do
      true ->
        best =
          books
          |> Enum.sort_by(fn %Book{reviews: reviews} -> length(reviews) end, ordering)
          |> Enum.take(number)

        {:reply, best, state}

      _ ->
        {:reply, nil, state}
    end
  end

  def handle_info(:set_state, %State{books: books, genre: genre} = state) when length(books) == 0 do
    IO.puts "FIRST ROUND OF GETTING BOOKS"
    books =
      genre
      |> get_books()
      |> get_book_reviews()

    case Enum.all?(books, fn %Book{reviews: reviews} -> !is_nil(reviews) end) do
      true ->
        IO.puts("fetching books and reviews finished")
        {:noreply, %State{state | books: books}}

      _ ->
        IO.puts "BOOK LENGTH #{length(books)}"
        IO.puts "WAITING TO START SECOND ROUND"
        Process.send_after(self(), :set_state, 60_000)
        {:noreply, %State{state | books: books}}
    end
  end

  def handle_info(:set_state, %State{books: books} = state) do
    IO.puts "SECOND ROUND OF GETTING BOOKS AND REVIEWS"
    new_books = get_book_reviews(books)

    case Enum.all?(new_books, fn %Book{reviews: reviews} -> !is_nil(reviews) end) do
      true ->
        IO.puts("fetching books and reviews finished")
        Process.send_after(self(), :save_books_and_reviews, 1_000)
        {:noreply, %State{state | books: new_books}}

      _ ->
        Process.send_after(self(), :set_state, 60_000)
        {:noreply, %State{state | books: new_books}}
    end
  end

  def handle_info(:save_books_and_reviews, %State{books: books} = state) do
    books
    |> Enum.reject(fn book -> Library.does_book_exist?(book.title) end)
    |> Enum.each(fn book -> save_book(book) end)

    IO.puts("saving books and reviews finished")
    {:noreply, state}
  end

  # Helper Functions #

  def get_books(genre) do
    IO.puts "GETTING BOOKS"
    case ClientApi.get_books(genre) do
      {:ok, body} ->
        %{"results" => results} = Poison.decode!(body)

        results
        |> Enum.map(fn book -> book["book_details"] end)
        |> Enum.map(fn [head | _] -> head end)
        |> Enum.map(fn book ->
          %Book{
            title: book["title"],
            author: book["author"],
            genre: genre,
            description: book["description"],
            reviews: nil
          }
        end)
        # |> Enum.reject(fn book -> book["title"] == "THE YELLOW HOUSE" end)

      _ ->
        []
    end
  end

  def get_full_book_review("THE YELLOW HOUSE") do
    []
  end

  def get_full_book_review(name) do
    IO.puts "GETTING FULL BOOK REVIEW #{name}"
    case ClientApi.get_book_review(name) do
      {:ok, body} ->
        %{"results" => results} = Poison.decode!(body)

        case results do
          nil ->
            []

          _ ->
            results
            |> Enum.map(fn review ->
              %Review{
                summary: review["summary"],
                author: review["byline"],
                book_title: review["book_title"]
              }
            end)
        end

      _ ->
        nil
    end
  end

  def get_book_reviews(list, acc \\ [])

  def get_book_reviews([], acc) do
    acc
  end

  def get_book_reviews([%Book{title: title, reviews: nil} = book | tail], acc) do
    reviews = get_full_book_review(title)

    get_book_reviews(tail, [%Book{book | reviews: reviews}] ++ acc)
  end

  def get_book_reviews([book | tail], acc) do
    get_book_reviews(tail, [book] ++ acc)
  end

  def get_date do
    Timex.today() |> to_string()
  end

  def author_full_name("") do
    ["unknown", "unknown"]
  end

  def author_full_name(byline) do
    author_string = String.upcase(byline)

    case String.split(author_string, " ") do
      ["BY", first_name, last_name] ->
        [first_name, last_name]

      ["BY", first_name, _, last_name] ->
        [first_name, last_name]

      [first_name, last_name] ->
        [first_name, last_name]

      [first_name, _, last_name] ->
        [first_name, last_name]

      _ ->
        ["unknown", "unknown"]
    end
  end

  def find_author_id(byline) do
    [first_name, last_name] = author_full_name(byline)

    case News.does_author_exist?(first_name, last_name) do
      nil ->
        {:ok, struct} = News.insert_author(first_name, last_name)
        struct.id

      author ->
        author.id
    end
  end

  def save_author(first_name, last_name) do
    case News.does_author_exist?(first_name, last_name) do
      nil ->
        News.insert_author(first_name, last_name)

      author ->
        author
    end
  end

  def save_book(book) do
    [first_name, last_name] = author_full_name(book.author)

    save_author(first_name, last_name)
    |> Ecto.build_assoc(:books, %{
      title: book.title,
      genre: book.genre,
      description: book.description
    })
    |> Library.insert_book()

    Enum.each(book.reviews, fn review -> save_review(review) end)
  end

  def save_review(review) do
    case review do
      [] ->
        nil

      %Review{summary: summary, author: author, book_title: book_title} ->
        [first_name, last_name] = author_full_name(author)
        book_id = Library.find_book_id!(book_title)

        save_author(first_name, last_name)
        |> Ecto.build_assoc(:reviews, %{summary: summary, book_id: book_id})
        |> Library.insert_review()
    end
  end
end
