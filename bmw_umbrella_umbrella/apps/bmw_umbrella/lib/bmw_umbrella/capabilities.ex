defmodule BmwUmbrella.Capabilities do
  @moduledoc """
  The Capabilities context.
  """

  import Ecto.Query, warn: false
  alias BmwUmbrella.Repo

  alias BmwUmbrella.Capabilities.VehicleHelpers

  @doc """
  Returns the list of vehicles.

  ## Examples

      iex> list_vehicles()
      [%Vehicle{}, ...]

  """
  def list_vehicles do
    Repo.all(VehicleHelpers)
  end

  @doc """
  Gets a single vehicle.

  Raises `Ecto.NoResultsError` if the Vehicle does not exist.

  ## Examples

      iex> get_vehicle!(123)
      %Vehicle{}

      iex> get_vehicle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicle!(id), do: Repo.get!(VehicleHelpers, id)

  def get_vehicle_by_vin!(vin) do
    VehicleHelpers
    |> where([v], v.vin == ^vin)
    |> Repo.one()
  end

  @doc """
  Creates a vehicle.

  ## Examples

      iex> create_vehicle(%{field: value})
      {:ok, %Vehicle{}}

      iex> create_vehicle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vehicle(attrs \\ %{}) do
    %VehicleHelpers{}
    |> VehicleHelpers.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vehicle.

  ## Examples

      iex> update_vehicle(vehicle, %{field: new_value})
      {:ok, %Vehicle{}}

      iex> update_vehicle(vehicle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicle(%VehicleHelpers{} = vehicle, attrs) do
    vehicle
    |> VehicleHelpers.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Vehicle.

  ## Examples

      iex> delete_vehicle(vehicle)
      {:ok, %Vehicle{}}

      iex> delete_vehicle(vehicle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicle(%VehicleHelpers{} = vehicle) do
    Repo.delete(vehicle)
  end

  def delete_vehicle_by_id(id) do
    VehicleHelpers
    |> where([v], v.id == ^id)
    |> Repo.one()
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle changes.

  ## Examples

      iex> change_vehicle(vehicle)
      %Ecto.Changeset{source: %Vehicle{}}

  """
  def change_vehicle(%VehicleHelpers{} = vehicle) do
    VehicleHelpers.changeset(vehicle, %{})
  end
end
