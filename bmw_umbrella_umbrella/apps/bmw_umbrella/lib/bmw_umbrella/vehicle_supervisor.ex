defmodule BmwUmbrella.VehicleSupervisor do
  use Supervisor

   alias BmwUmbrella.Vehicle
   alias BmwUmbrella.Capabilities

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child(vin) do
    Supervisor.start_child(__MODULE__, [vin])
  end

  # CALLBACKS #

  def init([]) do
    # children = [
    #   worker(Vehicle), 
    # ]
  end
end