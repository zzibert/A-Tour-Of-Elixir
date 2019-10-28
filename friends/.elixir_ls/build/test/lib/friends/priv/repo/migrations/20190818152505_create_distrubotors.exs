defmodule Friends.Repo.Migrations.CreateDistrubotors do
  use Ecto.Migration

  def change do
    create table(:distrubutors) do
      add :name, :string
      add :movie_id, references(:movies)
    end
  end
end
