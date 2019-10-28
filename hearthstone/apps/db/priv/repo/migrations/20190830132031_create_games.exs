defmodule Db.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def up do
    create table(:games) do
      add :name, :string
    end
  end

  def down do
    drop table(:games)
  end
end






