defmodule BmwUmbrellaWeb.ContainerController do
  use BmwUmbrellaWeb, :controller

  alias BmwUmbrella.BusinessLogic

  # def index(conn, _params) do
  #   body = %{one: "one", two: "two", three: "three"}
  #   json(conn, %{data: body})
  # end

  def receive_vin_and_container_id(conn, %{"vin" => vin, "container_id" => container_id} = params) do
    case BusinessLogic.vin_container_compatibility?(vin, container_id) do
      true ->
        json(conn, %{response: "VIN and container ID are compatible."})

      false ->
        json(conn, %{response: "vin and container are not compatible."})
    end
  end
end
