defmodule PhoenixHomeProjectWeb.PageController do
  use PhoenixHomeProjectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
