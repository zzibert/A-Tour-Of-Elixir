defmodule BmwUmbrella.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :vin, :string, null: false
      add :token, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:vin])
    create unique_index(:users, [:token])
  end
end
