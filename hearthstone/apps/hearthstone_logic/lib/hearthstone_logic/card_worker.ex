defmodule HearthstoneLogic.CardWorker do
  use GenServer

  alias HearthstoneLogic.ClientApi
  alias HearthstoneLogic.Helpers.Card
  alias Db.Library

  defmodule State do
    defstruct cards: []
  end

  # defmodule Card do
  #   defstruct name: "",
  #             text: "",
  #             flavor: "",
  #             attack: "",
  #             class: "",
  #             cost: "",
  #             health: "",
  #             type: "",
  #             rarity: ""
  # end

  # API #

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_card_by_id!(card_name) do
    GenServer.call(__MODULE__, {:get_card, card_name})
  end

  def get_cards() do
    GenServer.call(__MODULE__, :get_cards)
  end

  # Callbacks #

  def init([]) do
    if Mix.env() != :test do
      Process.send_after(self(), :set_state, 10)
    end

    {:ok, %State{}}
  end

  def handle_call({:get_card, card_id}, _from, %{cards: cards} = state) do
    card = Enum.find(cards, fn card -> card.id == card_id end)
    {:reply, card, state}
  end

  def handle_call(:get_cards, _from, %{cards: cards} = state) do
    {:reply, cards, state}
  end

  def handle_info(:set_state, %State{cards: cards} = state) when length(cards) == 0 do
    get_cards_from_api()
    cards = Library.get_all_cards!()
    Process.send_after(self(), :set_state, 3600_000)
    {:noreply, %State{state | cards: cards}}
  end

  # Helper Functions #

  defp get_cards_from_api() do
    case ClientApi.get_all_cards() do
      {:ok, body} ->
        Poison.decode!(body)
        |> Enum.reject(fn card ->
          is_nil(card["attack"]) or card["attack"] == 0 or is_nil(card["name"])
        end)
        |> Enum.map(fn card -> Card.upsert(card) end)

      _ ->
        nil
    end
  end
end
