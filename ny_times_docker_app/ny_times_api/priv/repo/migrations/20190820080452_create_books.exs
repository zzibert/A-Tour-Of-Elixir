defmodule NyTimesApi.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def up do
    create table(:books) do
      add :title, :string
      add :genre, :string
      add :description, :string
      add :author_id, references(:authors)
    end
  end

  def down do
    drop table(:books)
  end
end
