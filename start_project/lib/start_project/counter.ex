defmodule StartProject.Counter do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def greetings(first_name) do
    GenServer.call(String.to_atom(first_name), {:greeting, first_name})
  end

  def init(_name) do
    {:ok, 0}
  end

  # Callbacks

  def handle_call({:greeting, first_name}, _from, counter) do
    {:reply, "Hello, #{first_name} was called #{counter + 1} times", counter + 1}
  end
end
