defmodule NyTimesApi.Db.News.Story do
  use Ecto.Schema

  alias NyTimesApi.Db.News.Author

  schema "stories" do
    field(:date, :string)
    field(:title, :string)
    field(:segment, :string)
    belongs_to(:author, Author)
  end
end
