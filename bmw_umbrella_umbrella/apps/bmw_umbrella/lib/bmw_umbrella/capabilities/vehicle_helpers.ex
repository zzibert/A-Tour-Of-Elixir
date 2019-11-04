defmodule BmwUmbrella.Capabilities.VehicleHelpers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_helpers" do
    field :vehicle_brand_is_supported, :boolean, default: false
    field :clearance_id, :string
    field :vehicle_has_activated_sim, :boolean, default: false
    field :vehicle_is_mapped_to_customer, :boolean, default: false
    field :vehicle_is_telematics_capable, :boolean, default: false
    field :vehicle_market_is_supported, :boolean, default: false
    field :token, :string
    field :vin, :string

    timestamps()
  end

  @doc false
  def changeset(vehicle_helpers, attrs) do
    vehicle_helpers
    |> cast(attrs, [
      :vin,
      :token,
      :clearance_id,
      :vehicle_is_telematics_capable,
      :vehicle_has_activated_sim,
      :vehicle_is_mapped_to_customer,
      :vehicle_market_is_supported,
      :vehicle_brand_is_supported
    ])
    |> validate_required([
      :vin,
      :vehicle_is_telematics_capable,
      :vehicle_has_activated_sim,
      :vehicle_is_mapped_to_customer,
      :vehicle_market_is_supported,
      :vehicle_brand_is_supported
    ])
  end
end
