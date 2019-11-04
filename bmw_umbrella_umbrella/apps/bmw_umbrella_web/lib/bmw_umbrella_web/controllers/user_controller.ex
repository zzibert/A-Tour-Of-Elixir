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
        response = BusinessLogic.check_if_vehicle_in_db(params["vin"], params["token"])
        json(conn, response)

      false ->
        json(conn, %{user: "invalid"})
    end
  end
end
