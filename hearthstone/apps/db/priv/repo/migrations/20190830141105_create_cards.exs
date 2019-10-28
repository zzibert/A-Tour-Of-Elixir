defmodule Db.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def up do
    create table(:cards) do
      add :name, :string
      add :text, :string
      add :flavor, :string
      add :attack, :integer
      add :class, :string
      add :cost, :integer
      add :health, :integer
      add :type, :string
      add :rarity, :string
    end
  end

  def down do
    drop table(:cards)
  end
end
