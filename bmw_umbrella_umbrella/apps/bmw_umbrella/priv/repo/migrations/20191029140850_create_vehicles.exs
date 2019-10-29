defmodule BmwUmbrella.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :vin, :string
      add :" capabilities", :map

      timestamps()
    end

    create unique_index(:vehicles, [:vin])
  end
end
