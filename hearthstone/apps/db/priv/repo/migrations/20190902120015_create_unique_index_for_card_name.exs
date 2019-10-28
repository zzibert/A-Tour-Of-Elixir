defmodule Db.Repo.Migrations.CreateUniqueIndexForCardName do
  use Ecto.Migration

  def change do
    create unique_index(:cards, [:name])
  end
end
