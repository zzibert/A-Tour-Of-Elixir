defmodule NyTimesApi.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def up do
    create table(:authors) do
      add :first_name, :string
      add :last_name, :string
    end
  end

  def down do
    drop table(:authors)
  end
end
