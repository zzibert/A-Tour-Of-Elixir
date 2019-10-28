defmodule Kafka.Producer do
  use GenServer

  defmodule State do
    defstruct cards: []
  end

  # API #

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def send_card(card, table) do
    GenServer.call(__MODULE__, {:sending_card, card, table})
  end

  # CALLBACKS #

  def init([]) do
    {:ok, %State{}}
  end

  def handle_call({:sending_card, card, table}, _from, state) do
    card_and_table = Poison.encode!(%{"card" => card, "table" => table})
    KafkaEx.produce("cards", 0, card)
    {:reply, card, state}
  end
end
