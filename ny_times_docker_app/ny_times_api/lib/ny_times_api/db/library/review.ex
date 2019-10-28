defmodule NyTimesApi.Db.Library.Review do
  use Ecto.Schema
  import Ecto.Changeset

  alias NyTimesApi.Db.Library.Book
  alias NyTimesApi.Db.News.Author

  schema "reviews" do
    field(:summary, :string)
    belongs_to(:book, Book)
    belongs_to(:author, Author)
  end

  def changeset(review, params \\ %{}) do
    review
    |> cast(params, [:summary])
    |> validate_required([:summary])
  end
end
