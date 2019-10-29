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
    
  end
end