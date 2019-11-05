defmodule BmwUmbrella.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      # supervisor(BmwUmbrella.VehicleSupervisor, []),
      BmwUmbrella.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BmwUmbrella.Supervisor)
  end
end
