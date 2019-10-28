defmodule Kafka.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  alias Kafka.Producer.Producer

  # API #

  # CALLBACKS #

  def start(_type, _args) do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, Producer},
      {:size, 5},
      {:max_overflow, 4}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    opts = [strategy: :one_for_one, name: Kafka.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # PRIVATE FUNCTIONS #

  defp pool_name() do
    :example_pool
  end

  def parallel_pool(range) do
    Enum.each(range, fn x -> spawn(fn -> pool_send_to_kafka(x) end) end)
  end

  defp pool_send_to_kafka(x) do
    :poolboy.transaction(pool_name(), fn pid -> Producer.produce_call(pid, x) end, :infinity)
  end
end
