defmodule BmwUmbrellaWeb.UserController do
  use BmwUmbrellaWeb, :controller

  def index(conn, _params) do
    body = %{one: "one", two: "two", three: "three"}
    json(conn, %{data: body})
  end
  
  def receive_vin_and_token(conn, params) do
    json(conn, params)
  end
end