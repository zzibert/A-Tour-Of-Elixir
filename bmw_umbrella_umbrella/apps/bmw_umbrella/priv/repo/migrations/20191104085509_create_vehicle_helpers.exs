defmodule BmwUmbrella.Repo.Migrations.CreateVehicleHelpers do
  use Ecto.Migration

  def change do
    create table(:vehicle_helpers) do
      add :vin, :string
      add :token, :string
      add :clearance_id, :string
      add :vehicle_is_telematics_capable, :boolean, default: false, null: false
      add :vehicle_has_activated_sim, :boolean, default: false, null: false
      add :vehicle_is_mapped_to_customer, :boolean, default: false, null: false
      add :vehicle_market_is_supported, :boolean, default: false, null: false
      add :vehicle_brand_is_supported, :boolean, default: false, null: false

      timestamps()
    end
  end
end
