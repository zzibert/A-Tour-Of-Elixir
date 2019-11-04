defmodule BmwUmbrella.Repo.Migrations.CreateVehicleHelpers do
  use Ecto.Migration

  def change do
    create table(:vehicle_helpers) do
      add :vin, :string
      add :token, :string
      add :clearance_id, :string
      add :is_telematics_capable, :boolean, default: false, null: false
      add :has_activated_sim, :boolean, default: false, null: false
      add :is_mapped_to_customer, :boolean, default: false, null: false
      add :market_is_supported, :boolean, default: false, null: false
      add :brand_is_supported, :boolean, default: false, null: false

      timestamps()
    end
  end
end
