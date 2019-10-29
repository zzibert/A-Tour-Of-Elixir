defmodule BmwUmbrella.Capabilities.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :" capabilities", :map
    field :vin, :string

    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:vin, :" capabilities"])
    |> validate_required([:vin, :" capabilities"])
    |> unique_constraint(:vin)
  end
end
