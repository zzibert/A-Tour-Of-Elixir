defmodule HearthstoneLogic.GameSupervisor do
  use Supervisor

  alias HearthstoneLogic.Game

  # API #

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(game_name) do
    Supervisor.start_child(__MODULE__, [game_name])
  end

  # CALLBACKS #

  def init([]) do
    children = [
      worker(Game, [], restart: :transient)
    ]

    opts = [strategy: :simple_one_for_one]

    supervise(children, opts)
  end
end
