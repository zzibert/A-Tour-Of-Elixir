defmodule Kafka.Producer.Producer do
  use GenServer

  defmodule State do
    defstruct topic: Application.get_env(:kafka, :topic),
              partition: Application.get_env(:kafka, :partition),
              name: ""
  end

  # API #

  def start_link([]) do
    GenServer.start_link(__MODULE__, [])
  end

  def produce_call(pid, payload) do
    GenServer.call(pid, {:produce_call, payload})
  end

  def produce_cast(pid, payload) do
    GenServer.cast(pid, {:produce_cast, payload})
  end

  def square(pid, x) do
    GenServer.call(pid, {:square, x})
  end

  # CALLBACKS #

  def init([]) do
    name = random_string()
    KafkaEx.create_worker(name)
    {:ok, %State{name: name}}
  end

  def handle_call({:square, x}, _from, state) do
    :timer.sleep(2000)
    result = x * x
    IO.puts("Worker reports: #{x} * #{x} = #{result}")
    {:reply, [result], state}
  end

  def handle_call({:produce_call, payload}, _from, state) do
    # update_spiral("kafka_producer_counter", 1) ? 
    :timer.sleep(2000)

    IO.puts("I am worker - #{state.name}")

    KafkaEx.produce(
      state.topic,
      state.partition,
      payload |> Jason.encode!(),
      worker_name: state.name,
      required_acks: 1
    )

    {:reply, [], state}
  end

  def handle_cast({:produce_cast, payload}, state) do
    # update_spiral("kafka_producer_counter", 1) ? 
    :timer.sleep(2000)

    message =
      KafkaEx.produce(
        state.topic,
        state.partition,
        payload |> Jason.encode!(),
        worker_name: state.name,
        required_acks: 1
      )

    {:noreply, state}
  end

  def random_string() do
    "abcdefghijklmnoprstuvz"
    |> String.split("", trim: true)
    |> Enum.shuffle()
    |> Enum.take(5)
    |> Enum.join()
    |> String.to_atom()
  end
end
