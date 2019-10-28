defmodule Db.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def up do
    create table(:rounds) do
      
    end
  end

  def down do
    drop table(:rounds)
  end
end
