defmodule BmwUmbrella.CapabilitiesTest do
  use BmwUmbrella.DataCase

  alias BmwUmbrella.Capabilities

  describe "vehicles" do
    alias BmwUmbrella.Capabilities.Vehicle

    @valid_attrs %{" capabilities": %{}, vin: "some vin"}
    @update_attrs %{" capabilities": %{}, vin: "some updated vin"}
    @invalid_attrs %{" capabilities": nil, vin: nil}

    def vehicle_fixture(attrs \\ %{}) do
      {:ok, vehicle} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Capabilities.create_vehicle()

      vehicle
    end

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert Capabilities.list_vehicles() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Capabilities.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      assert {:ok, %Vehicle{} = vehicle} = Capabilities.create_vehicle(@valid_attrs)
      assert vehicle.capabilities == %{}
      assert vehicle.vin == "some vin"
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Capabilities.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{} = vehicle} = Capabilities.update_vehicle(vehicle, @update_attrs)
      assert vehicle.capabilities == %{}
      assert vehicle.vin == "some updated vin"
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Capabilities.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Capabilities.get_vehicle!(vehicle.id)
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Capabilities.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Capabilities.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Capabilities.change_vehicle(vehicle)
    end
  end
end
