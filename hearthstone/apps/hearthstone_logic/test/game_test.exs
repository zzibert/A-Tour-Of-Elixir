defmodule HearthstoneLogic.Test.GameTest do
  use ExUnit.Case

  alias HearthstoneLogic.GameSupervisor
  alias HearthstoneLogic.UserSupervisor
  alias HearthstoneLogic.Game
  alias HearthstoneLogic.User

  defp create_random_name() do
    "abcdefghijklmnoprstuvz"
    |> String.split("", trim: true)
    |> Enum.shuffle()
    |> Enum.take(Enum.random(5..10))
    |> Enum.join()
  end

  defp add_random_user_with_x_cards(game, number_of_cards) do
    user_name = create_random_name()

    UserSupervisor.start_child(user_name)

    Enum.each(1..number_of_cards, fn _ -> User.add_card_to_deck(user_name, create_card()) end)

    Game.select_user(game, user_name)
  end

  defp create_users_and_start_game(game_name) do
    {:ok, user1} = add_random_user_with_x_cards(game_name, 10)
    {:ok, user2} = add_random_user_with_x_cards(game_name, 10)

    Game.start(game_name)

    {user1, user2}
  end

  defp create_card() do
    Enum.random(1..2164)
  end

  setup do
    random_name = create_random_name()

    {:ok, pid} = GameSupervisor.start_child(random_name)

    %{name: random_name, pid: pid}
  end

  describe "game worker tests" do
    test "1. game is in inactive status when its launched", %{name: name} do
      assert :inactive == Game.get_status(name)
    end

    test "2. game users list is empty", %{name: name} do
      assert [] == Game.get_users(name)
    end

    test "3. user is added to the game", %{name: name} do
      user_name = create_random_name()

      UserSupervisor.start_child(user_name)
      Enum.each(1..10, fn _ -> User.add_card_to_deck(user_name, create_card()) end)

      Game.select_user(name, user_name)
      [user] = Game.get_users(name)
      assert user_name == user.name
    end

    test "4. user is removed from game", %{name: name} do
      {:ok, user_name} = add_random_user_with_x_cards(name, 10)

      Game.remove_user(name, user_name)

      assert [] == Game.get_users(name)
    end

    test "5. user cant be removed, game is already started", %{name: name} do
      {user1, user2} = create_users_and_start_game(name)

      assert {:error, :game_is_active} == Game.remove_user(name, user1)
    end

    test "6. remove non-existing user from game", %{name: name} do
      assert {:error, :user_not_present} == Game.remove_user(name, create_random_name())
    end

    test "7. can not add more than two users to the game", %{name: name} do
      Enum.each(1..2, fn _ -> add_random_user_with_x_cards(name, 10) end)
      assert {:error, :already_two_users} == add_random_user_with_x_cards(name, 10)
    end

    test "8. can not start game without two users", %{name: name} do
      Game.select_user(name, create_random_name())
      assert {:error, :not_enough_users} == Game.start(name)
    end

    test "9. can not start game without both users having 10 cards", %{name: name} do
      add_random_user_with_x_cards(name, 10)
      add_random_user_with_x_cards(name, 9)

      assert {:error, :not_enough_users} == Game.start(name)
    end

    test "10. game is started, status is active", %{name: name} do
      add_random_user_with_x_cards(name, 10)
      add_random_user_with_x_cards(name, 10)

      Game.start(name)

      assert :active == Game.get_status(name)
    end

    test "11. both users start with 30 health", %{name: name} do
      {user1, user2} = create_users_and_start_game(name)

      assert 30 == Game.get_health(name, user1)
      assert 30 == Game.get_health(name, user2)
      assert {:error, :user_not_found} == Game.get_health(name, create_random_name())
    end

    test "12. both users have their deck in the game state and its shuffled", %{name: name} do
      {user1, user2} = create_users_and_start_game(name)

      assert 10 == length(Game.get_deck(name, user1))
      assert 10 == length(Game.get_deck(name, user2))
      assert {:error, :user_not_found} = Game.get_deck(name, create_random_name())
    end

    test "13. Game worker chooses which user has first turn", %{name: name} do
      {user1, _user2} = create_users_and_start_game(name)

      assert user1 == Game.who_has_turn(name)
    end

    test "14. user draws a card when its hes turn", %{name: name} do
      {user1, user2} = create_users_and_start_game(name)
      send(String.to_atom(name), :draw_card)
      assert 1 == length(Game.get_hand(name, user1))
      assert 0 == length(Game.get_hand(name, user2))
    end

    test "15. user can end turn only when its hes turn", %{name: name} do
      {_user1, user2} = create_users_and_start_game(name)

      assert {:error, :not_your_turn} == Game.end_turn(name, user2)
    end

    test "16. user ends turn, other user draws a card and its hes turn", %{name: name} do
      {user1, user2} = create_users_and_start_game(name)

      assert {:ok, :end_of_turn} == Game.end_turn(name, user1)

      send(String.to_atom(name), :draw_card)

      assert user2 == Game.who_has_turn(name)

      assert 1 == length(Game.get_hand(name, user2))
    end

    test "17. user can only play a card when its hes turn", %{name: name} do
      {_user1, user2} = create_users_and_start_game(name)

      assert {:error, :not_your_turn} == Game.play_card(name, user2, create_card())
    end

    test "18. user can only play cards from hes hand", %{name: name} do
      {user1, _user2} = create_users_and_start_game(name)

      assert {:error, :card_not_found} == Game.play_card(name, user1, 9999)
    end

    test "19. user not found", %{name: name} do
      {_user1, _user2} = create_users_and_start_game(name)

      assert {:error, :user_not_found} ==
               Game.play_card(name, create_random_name(), create_card())
    end

    test "20. user plays a card, that card is not longer in hand", %{name: name} do
      {user1, _user2} = create_users_and_start_game(name)
      send(String.to_atom(name), :draw_card)
      [card_id] = Game.get_hand(name, user1)

      assert {:ok, card} = Game.play_card(name, user1, card_id)

      assert [] == Game.get_hand(name, user1)
    end

    test "21. user ends turn, other user draws a card", %{name: name} do
      {user1, _user2} = create_users_and_start_game(name)
      Game.end_turn(name, user1)
      send(String.to_atom(name), :draw_card)
    end

    test "22. user plays a card, deals damage to the opponent", %{name: name} do
      {user1, user2} = create_users_and_start_game(name)
      send(String.to_atom(name), :draw_card)
      [card_id] = Game.get_hand(name, user1)

      {:ok, card} = Game.play_card(name, user1, card_id)

      assert 30 - card[:attack] == Game.get_health(name, user2)
    end

    test "23. user has less than one health, winner is declared, game worker is stopped", %{
      name: name
    } do
      {user1, user2} = create_users_and_start_game(name)
      send(String.to_atom(name), :draw_card)
      [card_id] = Game.get_hand(name, user1)

      {:ok, card} = Game.play_card(name, user1, card_id)

      assert 0 == Game.get_health(name, user2)

      Game.end_turn(name, user1)

      assert nil == Process.whereis(String.to_atom(name))
    end
  end
end
