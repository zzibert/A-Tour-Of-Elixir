defmodule BmwUmbrella.Capabilities.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :vin, :string
    field :vehicle_is_telematics_capable, :boolean
    field :vehicle_has_activated_sim, :boolean
    field :vehicle_is_mapped_to_customer, :boolean
    field :vehicle_market_is_supported, :boolean
    field :vehicle_brand_is_supported, :boolean

    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [
      :vin,
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
    |> unique_constraint(:vin)
  end
end
