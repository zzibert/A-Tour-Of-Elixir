defmodule BmwUmbrellaWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      BmwUmbrellaWeb.Endpoint
      # Starts a worker by calling: BmwUmbrellaWeb.Worker.start_link(arg)
      # {BmwUmbrellaWeb.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BmwUmbrellaWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BmwUmbrellaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
