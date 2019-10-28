defmodule NyTimesApi.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def up do
    create table(:reviews) do
      add :summary, :string
      add :book_id, references(:books)
      add :author_id, references(:authors)
    end
  end

  def down do
    drop table(:reviews)
  end
end
