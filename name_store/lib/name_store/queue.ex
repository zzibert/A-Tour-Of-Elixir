defmodule NameStore.Queue do
  use GenServer

  # API #

  def start_link() do
      GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def put(name) do
    GenServer.call(__MODULE__, {:put, name})
  end

  def get() do
    GenServer.call(__MODULE__, {:get, "idk"})
  end

  def init(_name) do
      {:ok, [] }
  end

  # Callbacks

  def handle_call({:put, name}, _from, names) do
    {:reply, :added, [name | names] |> Enum.sort }
  end

  def handle_call({:get, "idk"}, _from, names) do
  # def handle_call({:get, "idk"}, _from, [head | tail]) do
    # {:reply, head, tail}
    {:reply, List.first(names), names |> Enum.reject(fn x -> x == List.first(names) end)}
  end
end
