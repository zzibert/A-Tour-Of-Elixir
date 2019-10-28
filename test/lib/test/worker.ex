defmodule Test.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def say_hello(first_name, last_name) do
    case first_name do

      "ziga" -> GenServer.call(String.to_atom(first_name), {:hello_ziga, last_name})

      _ -> GenServer.call(String.to_atom(first_name), {:hello, last_name})
    end


  end

  def init(name) do
    Process.send_after(String.to_atom(name), :timer, 5 * 1000)
    {:ok, name}
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def handle_call({:hello, last_name}, _from, first_name) do
    Process.send_after(self, :stop, 5 * 1000)
     {:reply, "Hello, #{first_name} #{last_name}", first_name }
  end

  def handle_call({:hello_ziga, last_name}, _from, first_name) do
    {:stop, :normal, "Hello, #{last_name}", first_name}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_info(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_info(:timer, %{counter: x} = state) when x == 5 do
    IO.puts DateTime.utc_now
    {:stop, state}
  end

  def handle_info(:timer, state) do
    IO.puts DateTime.utc_now
    Process.send_after(self, :timer, 5 * 1000)
    {:noreply, %{state | counter: x + 1}}
  end

  def handle_info(:timer, %{counter: x} = state) when x > 5 do
    IO.puts DateTime.utc_now
    Process.send_after(self, :timer, 5 * 1000)
    {:noreply, state}
  end
end
