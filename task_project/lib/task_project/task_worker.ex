defmodule TaskProject.TaskWorker do
  use GenServer

  # Client #

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def crunch_numbers(list_of_numbers) do
    stream = Task.Supervisor.async_stream(TaskProject.TaskSupervisor, list_of_numbers, fn number -> factorial(number) end, timeout: 60_000)
    Enum.reduce(stream, 0, fn {:ok, num}, acc -> num + acc end)
  end

  # Callbacks #

  def init(name) do
    {:ok, name}
  end

  # Private Functions #

  def multiply([head]) do
    head
  end

  def multiply([head | tail]) do
    Process.sleep(2_000)
    head * multiply(tail)
  end

  def factorial(1) do
    1
  end

  def factorial(n) do
    Process.sleep(5_000)
    n * factorial(n - 1)
  end
end