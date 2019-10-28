defmodule Kafka.Producer.ProducerSupervisor do
  use Supervisor
  alias Kafka.Producer.Producer

  # API #

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def produce_call(topic, partition, payload) do
    Producer.produce_call(take_random_worker(), topic, partition, payload)
  end

  def produce_cast(topic, partition, payload) do
    Producer.produce_cast(take_random_worker(), topic, partition, payload)
  end

  # CALLBACKS #

  def init([]) do
    number_of_workers = Application.get_env(:kafka, :producer_pool_size)

    children =
      1..number_of_workers
      |> Enum.map(fn x -> worker(Producer, [String.to_atom("worker#{x}")], id: x) end)

    opts = [strategy: :one_for_one]
    supervise(children, opts)
  end

  # PRIVATE FUNCTIONS #

  defp take_random_worker do
    __MODULE__
    |> Supervisor.which_children()
    |> Enum.map(fn {_, pid, _, _} -> pid end)
    |> Enum.random()
  end
end
