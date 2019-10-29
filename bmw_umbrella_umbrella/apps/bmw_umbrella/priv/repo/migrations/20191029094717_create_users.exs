defmodule BmwUmbrella.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :" vin", :string
      add :" token", :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [: vin])
    create unique_index(:users, [: token])
  end
end
