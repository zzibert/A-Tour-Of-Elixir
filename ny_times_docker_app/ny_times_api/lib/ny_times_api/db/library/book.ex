defmodule NyTimesApi.Db.Library.Book do
  use Ecto.Schema

  alias NyTimesApi.Db.Library.Review
  alias NyTimesApi.Db.News.Author

  schema "books" do
    field(:title, :string)
    field(:genre, :string)
    field(:description, :string)
    has_many(:reviews, Review)
    belongs_to(:author, Author)
  end
end
