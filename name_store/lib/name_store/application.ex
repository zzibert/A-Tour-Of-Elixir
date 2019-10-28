defmodule NameStore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      worker(NameStore.Queue, [])
      # Starts a worker by calling: NameStore.Worker.start_link(arg)
      # {NameStore.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NameStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
