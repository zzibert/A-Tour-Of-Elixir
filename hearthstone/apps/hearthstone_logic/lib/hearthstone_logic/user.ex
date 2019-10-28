defmodule HearthstoneLogic.User do
  use GenServer

  alias HearthstoneLogic.Helpers.User

  defmodule State do
    defstruct name: "",
              status: :pending,
              deck: []
  end

  # API #

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def get_deck(name) do
    GenServer.call(String.to_atom(name), :get_deck)
  end

  def add_card_to_deck(name, card_id) do
    GenServer.call(String.to_atom(name), {:add_card, card_id})
  end

  def remove_card_from_deck(name, card_id) do
    GenServer.call(String.to_atom(name), {:remove_card, card_id})
  end

  # Callback #

  def init(name) do
    if Mix.env() != :test do
      Process.send_after(self(), :find_user, 10)
    end

    {:ok, %State{name: name}}
  end

  def handle_call(:get_deck, _from, %{status: :pending} = state) do
    {:reply, {:error, :user_not_loaded}, state}
  end

  def handle_call(:get_deck, _from, %{deck: deck} = state) do
    {:reply, deck, state}
  end

  def handle_call({:add_card, card_id}, _from, %{deck: deck} = state) do
    cond do
      User.number_of_identical_cards(card_id, deck) > 2 ->
        {:reply, {:error, :card_limit}, state}

      length(deck) > 9 ->
        {:reply, {:error, :deck_limit}, state}

      true ->
        {:reply, {:ok, card_id}, %State{state | deck: [card_id | deck], status: :syncing}}
    end
  end

  def handle_call({:remove_card, card_id}, _from, %{deck: deck} = state) do
    case Enum.member?(deck, card_id) do
      true ->
        {:reply, {:ok, card_id},
         %State{state | deck: List.delete(deck, card_id), status: :syncing}}

      false ->
        {:reply, {:error, :card_not_present}, state}
    end
  end

  def handle_info(:find_user, %{name: name} = state) do
    deck = User.find_deck(name)
    Process.send_after(self(), :save_deck, 20_000)
    {:noreply, %State{state | deck: deck, status: :active}}
  end

  def handle_info(:save_deck, %{status: :active} = state) do
    Process.send_after(self(), :save_deck, 20_000)
    {:noreply, state}
  end

  def handle_info(:save_deck, %{status: :syncing} = state) do
    User.update_user(state)
    Process.send_after(self(), :save_deck, 20_000)
    {:noreply, %State{state | status: :active}}
  end
end
