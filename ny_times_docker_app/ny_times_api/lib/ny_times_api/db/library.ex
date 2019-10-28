defmodule NyTimesApi.Db.Library do
  import Ecto.Query

  alias NyTimesApi.Db.Library.Book
  alias NyTimesApi.Db.Library.Review
  alias NyTimesApi.Repo

  def get_book!(book_id) do
    Book
    |> where([b], b.id == ^book_id)
    |> Repo.one()
  end

  def get_books do
    Book
    |> Repo.all()
  end

  def does_book_exist?(title) do
    Book
    |> where([b], b.title == ^title)
    |> select([b], count(b.id) > 0)
    |> Repo.one()
  end

  def find_book_id!(title) do
    Book
    |> where([b], b.title == ^String.upcase(title))
    |> select([b], b.id)
    |> Repo.one()
  end

  def insert_books(books) do
    Repo.insert_all(Book, books)
  end

  def insert_book(book) do
    Repo.insert!(book)
  end

  # def insert_author(first_name, last_name) do
  #   Repo.insert(%Author{first_name: first_name, last_name: last_name})
  # end

  def get_review!(review_id) do
    Review
    |> where([r], r.id == ^review_id)
    |> Repo.one()
  end

  def get_reviews do
    Review
    |> Repo.all()
  end

  def insert_review(review) do
    Repo.insert!(review)
  end
end
