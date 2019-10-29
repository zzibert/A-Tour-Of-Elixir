defmodule BmwUmbrellaWeb.UserController do
  use BmwUmbrellaWeb, :controller

  alias BmwUmbrella.BusinessLogic

  def index(conn, _params) do
    body = %{one: "one", two: "two", three: "three"}
    json(conn, %{data: body})
  end
  
  def receive_vin_and_token(conn, params) do
    case BusinessLogic.valid_user?(params) do
      true ->
        json(conn, %{user: "valid"})
      false ->
        json(conn, %{user: "invalid"})
    end
  end
end