defmodule NyTimesApi.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def up do
    create table(:stories) do
      add :date, :string
      add :title, :string
      add :segment, :string
      add :author_id, references(:authors)
    end
  end

  def down do
    drop table(:stories)
  end
end
