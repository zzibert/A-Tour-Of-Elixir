defmodule BmwUmbrella.BusinessLogic do

  alias BmwUmbrella.Auth

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
end