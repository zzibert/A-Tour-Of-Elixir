defmodule BmwUmbrella.BusinessLogic.VinWorker do
  use GenServer

  alias BmwUmbrella.ClientApi

  defmodule State do
    defstruct vin: ""
  end

  # API #

  def start_link(vin) do
    GenServer.start_link(__MODULE__, vin, name: String.to_atom(vin))
  end

  def fetch__data(vin, clearance_id) do
    GenServer.call(String.to_atom(vin), {:fetch_data, clearance_id})
  end


  # CALLBACKS #

  def init(vin) do
    {:ok, %State{vin: vin}}
  end

  def handle_call({:fetch_data, clearance_id}, %State{vin: vin} = state) do
    data = ClientApi.access_to_telematics_data(clearance_id)
    {:reply, data, state}
  end

  # Private functions

  defp send_data_to_kafka(data) do
    data
  end


end