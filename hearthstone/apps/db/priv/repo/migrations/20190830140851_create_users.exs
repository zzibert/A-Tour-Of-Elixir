defmodule Db.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name, :string
      add :deck, {:array, :integer}
      add :game_id, references(:games)
    end
  end

  def down do
    drop table(:users)
  end
end
