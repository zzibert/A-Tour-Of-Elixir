defmodule BmwUmbrella.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :vin, :string
      add :vehicle_is_telematics_capable, :boolean
      add :vehicle_has_activated_sim, :boolean
      add :vehicle_is_mapped_to_customer, :boolean
      add :vehicle_market_is_supported, :boolean
      add :vehicle_brand_is_supported, :boolean

      timestamps()
    end

    create unique_index(:vehicles, [:vin])
  end
end
