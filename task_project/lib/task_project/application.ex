defmodule TaskProject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec
  alias TaskProject.TaskWorker

  def start(_type, _args) do
    children = [
      # {Task.Supervisor, name: TaskProject.TaskSupervisor},
      {Task.Supervisor, name: TaskProject.TaskSupervisor},
      worker(TaskWorker, ["ena"])
      # Starts a w  orker by calling: TaskProject.Worker.start_link(arg)
      # {TaskProject.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  
end
