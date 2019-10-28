defmodule HearthstoneLogic.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(HearthstoneLogic.UserSupervisor, []),
      supervisor(HearthstoneLogic.GameSupervisor, []),
      worker(HearthstoneLogic.CardWorker, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HearthstoneLogic.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
