defmodule Test.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def init([]) do
    children = [
      worker(Test.Worker, [], restart: :permanent)
    ]
    opts = [strategy: :simple_one_for_one]

    supervise(children, opts)
  end
end
