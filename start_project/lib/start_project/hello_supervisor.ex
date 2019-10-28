defmodule StartProject.HelloSupervisor do
  use Supervisor

  alias StartProject.{Hello}

  # API #

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def greetings(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  # Callbacks #

  def init([]) do
    children = [
      worker(Hello, [], restart: :transient)
    ]

    opts = [strategy: :simple_one_for_one]

    supervise(children, opts)
  end
end
