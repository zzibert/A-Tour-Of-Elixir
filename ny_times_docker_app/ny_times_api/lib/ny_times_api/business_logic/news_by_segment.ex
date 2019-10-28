defmodule NyTimesApi.BusinessLogic.NewsBySegment do
  use GenServer

  import Ecto.Query

  alias NyTimesApi.BusinessLogic.ClientApi
  alias NyTimesApi.Repo
  alias NyTimesApi.Db.News.Story
  alias NyTimesApi.Db.News

  defmodule State do
    defstruct segment: "",
              news: %{}
  end

  # @genres ["hardcover-fiction", "paperback-nonfiction", "paperback-nonfiction", "hardcover-nonfiction"]

  # API #

  def start_link(segment) do
    GenServer.start_link(__MODULE__, segment, name: String.to_atom(segment))
  end

  def get_news(segment) do
    GenServer.call(String.to_atom(segment), {:get_news, segment})
  end

  def close_news(segment) do
    GenServer.call(String.to_atom(segment), :stop)
  end

  # Callbacks #

  def init(name) do
    Process.flag(:trap_exit, true)

    Process.send_after(self(), :set_state, 1_000)
    {:ok, %State{segment: name}}
  end

  def handle_call({:get_news, segment}, _from, state) do
    query = from(s in Story, select: s, where: s.segment == ^segment)
    news = Repo.all(query)
    {:reply, news, state}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, state}
  end

  def handle_info(:set_state, state) do
    news = fetch_news(state.segment)

    case news do
      [] ->
        {:stop, :normal, state}

      _ ->
        Process.send_after(self(), :set_state, 60_000)
        {:noreply, %{state | news: Enum.into(news, %{})}}
    end
  end

  def terminate(_, state) do
    IO.puts("#{state.segment} was stopped because it had no news.")
  end

  # Helper Functions #

  def fetch_news(segment) do
    case ClientApi.get_topstories(segment) do
      {:ok, body} ->
        %{"results" => results} = Poison.decode!(body)

        news =
          results
          |> Enum.take(-100)
          |> Enum.reject(fn news -> News.does_story_exist?(news["title"]) end)
          |> Enum.map(fn news ->
            %{
              date: news["published_date"],
              title: news["title"],
              segment: segment,
              author_id: find_author_id(news["byline"])
            }
          end)

        News.insert_stories(news)

        results
        |> Enum.take(5)
        |> Enum.map(fn news -> {news["published_date"], news["title"]} end)

      _ ->
        []
    end
  end

  def author_full_name("") do
    ["unknown", "unknown"]
  end

  def author_full_name(byline) do
    [_, first_name, last_name | _] = String.split(byline, " ")
    [first_name, last_name]
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
end
