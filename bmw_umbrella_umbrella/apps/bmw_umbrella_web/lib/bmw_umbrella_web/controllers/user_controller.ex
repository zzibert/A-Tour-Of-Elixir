defmodule BmwUmbrellaWeb.Api.UserController do
  use BmwUmbrellaWeb, :controller

  def index(conn, _params) do
    body = %{one: "one", two: "two", three: "three"}
    json(conn, %{data: body})
  end

  def show(conn, params) do
  end
end
