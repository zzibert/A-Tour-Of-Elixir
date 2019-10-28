defmodule Web.GameController do
  use Web, :controller

  alias HearthstoneLogic.GameSupervisor

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def start_game(conn, %{"game_name" => game_name}) do
    GameSupervisor.start_child(game_name)
    render(conn, "available_games.html", games: [game_name])
  end

  def generic_function(conn, _params) do
    15
  end
end
