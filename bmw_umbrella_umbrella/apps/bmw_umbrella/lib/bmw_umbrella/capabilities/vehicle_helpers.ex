defmodule BmwUmbrella.Capabilities.VehicleHelpers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicle_helpers" do
    field :brand_is_supported, :boolean, default: false
    field :clearance_id, :string
    field :has_activated_sim, :boolean, default: false
    field :is_mapped_to_customer, :boolean, default: false
    field :is_telematics_capable, :boolean, default: false
    field :market_is_supported, :boolean, default: false
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
      :is_telematics_capable,
      :has_activated_sim,
      :is_mapped_to_customer,
      :market_is_supported,
      :brand_is_supported
    ])
    |> validate_required([
      :vin,
      :token,
      :clearance_id,
      :is_telematics_capable,
      :has_activated_sim,
      :is_mapped_to_customer,
      :market_is_supported,
      :brand_is_supported
    ])
  end
end
