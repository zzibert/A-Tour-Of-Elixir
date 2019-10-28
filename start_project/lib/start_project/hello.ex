defmodule StartProject.Hello do
  use GenServer

  # API #

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def say_greetings(first_name, last_name) do
    GenServer.call(String.to_atom(first_name), {:greeting, last_name})
  end

  def init(name) do
    {:ok, name}
  end

  # Callbacks #

  def handle_call({:hello, last_name}, _from, first_name) do
    Process.send_after(self(), :stop, 5 * 1000)
    {:reply, "Hello #{first_name} #{last_name}", first_name}
  end

  # Example A

  # def handle_call({:greeting, last_name}, _from, first_name) do
  #     Process.send_after(self, :stop, 0)
  #     {:reply, "Hello, #{String.capitalize(first_name)} #{String.capitalize(last_name)}", first_name }
  # end

  # Example B
  def handle_call({:greeting, last_name}, _from, first_name) do
    {:stop, :normal, "Hello, #{String.capitalize(first_name)} #{String.capitalize(last_name)}",
     first_name}
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_info(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_info(:timer, %{counter: x} = state) when x == 5 do
    IO.puts(DateTime.utc_now())
    IO.puts("worker stopped after 5 times")
    {:stop, :normal, state}
  end

  def handle_info(:timer, %{counter: x} = state) do
    IO.puts(DateTime.utc_now())
    Process.send_after(self(), :timer, 5 * 1000)
    {:noreply, %{state | counter: x + 1}}
  end
end
