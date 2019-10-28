defmodule HearthstoneLogic.Game do
  use GenServer

  alias HearthstoneLogic.UserSupervisor
  alias HearthstoneLogic.User
  alias HearthstoneLogic.CardWorker

  defmodule State do
    defstruct name: "",
              status: :inactive,
              users: [],
              turn: ""
  end

  defmodule Player do
    defstruct name: "",
              health: 30,
              deck: [],
              hand: []
  end

  # API #

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def start(game_name) do
    GenServer.call(String.to_atom(game_name), :start)
  end

  def select_user(game_name, user_name) do
    GenServer.call(String.to_atom(game_name), {:select_user, user_name})
  end

  def remove_user(game_name, user_name) do
    GenServer.call(String.to_atom(game_name), {:remove_user, user_name})
  end

  def get_status(game_name) do
    GenServer.call(String.to_atom(game_name), :status)
  end

  def get_health(game_name, user_name) do
    GenServer.call(String.to_atom(game_name), {:get_health, user_name})
  end

  def get_deck(game_name, user_name) do
    GenServer.call(String.to_atom(game_name), {:get_deck, user_name})
  end

  def get_users(game_name) do
    GenServer.call(String.to_atom(game_name), :get_users)
  end

  def get_hand(game_name, user_name) do
    GenServer.call(String.to_atom(game_name), {:get_hand, user_name})
  end

  def play_card(game_name, user_name, card_id) do
    GenServer.call(String.to_atom(game_name), {:play_card, user_name, card_id})
  end

  def who_has_turn(game_name) do
    GenServer.call(String.to_atom(game_name), :who_has_turn)
  end

  def end_turn(game_name, user_name) do
    GenServer.call(String.to_atom(game_name), {:end_turn, user_name})
  end

  # CALLBACKS

  def init(name) do
    {:ok, %State{name: name}}
  end

  def handle_call(:status, _from, %{status: status} = state) do
    {:reply, status, state}
  end

  def handle_call({:select_user, user_name}, _from, %{users: users} = state) do
    case Process.whereis(String.to_atom(user_name)) do
      nil ->
        {:reply, {:error, :user_not_active}, state}

      _ ->
        cond do
          length(users) > 1 ->
            {:reply, {:error, :already_two_users}, state}

          length(User.get_deck(user_name)) != 10 ->
            {:reply, {:error, :user_has_not_enough_cards}, state}

          true ->
            {:reply, {:ok, user_name},
             %State{
               state
               | users: [%Player{name: user_name, deck: User.get_deck(user_name)} | users]
             }}
        end
    end
  end

  def handle_call({:remove_user, user_name}, _from, %{users: users, status: status} = state) do
    case status do
      :active ->
        {:reply, {:error, :game_is_active}, state}

      :inactive ->
        case Enum.filter(users, fn user -> user.name == user_name end) do
          [] ->
            {:reply, {:error, :user_not_present}, state}

          [user] ->
            {:reply, {:ok, user}, %State{state | users: List.delete(users, user)}}
        end
    end
  end

  def handle_call(:start, _from, %{users: users} = state) do
    cond do
      length(users) < 2 ->
        {:reply, {:error, :not_enough_users}, state}

      true ->
        if Mix.env() != :test do
          Process.send_after(self(), :draw_card, 10)
        end

        [_other_user | [first_user]] = users
        {:reply, {:ok, :game_started}, %State{state | status: :active, turn: first_user.name}}
    end
  end

  def handle_call(
        {:play_card, user_name, card_id},
        _from,
        %{users: users, turn: current_user} = state
      ) do
    case Enum.find(users, fn user -> user.name == user_name end) do
      nil ->
        {:reply, {:error, :user_not_found}, state}

      user ->
        case user.name == current_user do
          false ->
            {:reply, {:error, :not_your_turn}, state}

          true ->
            case Enum.member?(user.hand, card_id) do
              true ->
                card =
                  if Mix.env() != :test do
                    CardWorker.get_card_by_id!(card_id)
                  else
                    %{attack: 30}
                  end

                new_user = %Player{user | hand: List.delete(user.hand, card_id)}
                other_user = Enum.find(users, fn user -> user.name != current_user end)
                second_user = %Player{other_user | health: other_user.health - card.attack}
                {:reply, {:ok, card}, %{state | users: [new_user, second_user]}}

              false ->
                {:reply, {:error, :card_not_found}, state}
            end
        end
    end
  end

  def handle_call(:get_users, _from, %{users: users} = state) do
    {:reply, users, state}
  end

  def handle_call({:get_hand, user_name}, _from, %{users: users} = state) do
    [user] = Enum.filter(users, fn user -> user.name == user_name end)
    {:reply, user.hand, state}
  end

  def handle_call({:get_health, user_name}, _from, %{users: users} = state) do
    case Enum.find(users, fn user -> user.name == user_name end) do
      nil ->
        {:reply, {:error, :user_not_found}, state}

      user ->
        {:reply, user.health, state}
    end
  end

  def handle_call({:get_deck, user_name}, _from, %{users: users} = state) do
    case Enum.find(users, fn user -> user.name == user_name end) do
      nil ->
        {:reply, {:error, :user_not_found}, state}

      user ->
        {:reply, user.deck, state}
    end
  end

  def handle_call(:who_has_turn, _from, %{turn: turn} = state) do
    {:reply, turn, state}
  end

  def handle_call({:end_turn, user_name}, _from, %{users: users, turn: current_user} = state) do
    cond do
      user_name != current_user ->
        {:reply, {:error, :not_your_turn}, state}

      true ->
        case Enum.all?(users, fn user -> user.health > 0 end) do
          true ->
            if Mix.env() != :test do
              Process.send_after(self(), :draw_card, 10)
            end

            [other_user] = Enum.filter(users, fn user -> user.name != user_name end)
            {:reply, {:ok, :end_of_turn}, %State{state | turn: other_user.name}}

          false ->
            {:stop, :normal, {:game_finished, current_user}, state}
        end
    end
  end

  def handle_info(:draw_card, %{turn: turn, users: users} = state) do
    user = Enum.find(users, fn user -> user.name == turn end)

    new_user = %Player{
      user
      | hand: [Enum.at(user.deck, Enum.random(1..length(user.deck))) | user.hand]
    }

    {:noreply, %State{state | users: [new_user | List.delete(users, user)]}}
  end

  # HELPER FUNCTIONS #

  defp create_card() do
    Enum.random(1..2164)
  end
end
