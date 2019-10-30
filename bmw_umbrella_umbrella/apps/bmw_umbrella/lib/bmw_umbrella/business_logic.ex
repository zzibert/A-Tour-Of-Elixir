defmodule BmwUmbrella.BusinessLogic do
  alias BmwUmbrella.Auth
  alias BmwUmbrella.Capabilities
  alias BmwUmbrella.ClientApi

  def valid_token?(token) do
    case Auth.get_token_by_value!(token) do
      nil ->
        false

      _ ->
        true
    end
  end

  def valid_vin?(vin) do
    valid_vins = ["11111", "22222", "33333", "44444", "55555"]
    Enum.member?(valid_vins, vin)
  end

  def valid_user?(%{"vin" => vin, "token" => token} = user) do
    cond do
      !valid_token?(token) ->
        false

      !valid_vin?(vin) ->
        false

      true ->
        true
    end
  end

  def check_if_vehicle_in_db(vin) do
    case Capabilities.get_vehicle_by_vin!(vin) do
      nil ->
        {:ok, capabilities} = ClientApi.check_if_vehicle_is_bmw_cardata_capable(vin) 
        vehicle = [vin: vin] ++ for {key, value} <- capabilities, do: {String.to_atom(Macro.underscore(key)), value}

        Enum.into(vehicle, %{})
        |> Capabilities.create_vehicle()

      vehicle ->
        IO.inspect "trololo"
    end
  end
end
