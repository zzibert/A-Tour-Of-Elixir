defmodule NyTimesApi.Db.News.Author do
  use Ecto.Schema

  alias NyTimesApi.Db.News.Story
  alias NyTimesApi.Db.Library.Book
  alias NyTimesApi.Db.Library.Review

  schema "authors" do
    field(:first_name, :string)
    field(:last_name, :string)
    has_many(:stories, Story)
    has_many(:books, Book)
    has_many(:reviews, Review)
  end
end
