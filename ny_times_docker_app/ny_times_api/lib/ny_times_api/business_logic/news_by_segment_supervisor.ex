defmodule NyTimesApi.BusinessLogic.NewsBySegmentSupervisor do
  use Supervisor

  alias NyTimesApi.BusinessLogic.{NewsBySegment}

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(segment) do
    Supervisor.start_child(__MODULE__, [segment])
  end

  # Callbacks #

  def init([]) do
    children = [
      worker(NewsBySegment, [], restart: :transient)
    ]

    opts = [strategy: :simple_one_for_one]

    supervise(children, opts)
  end
end
