defmodule HearthstoneLogic.Test.UserTest do
  use ExUnit.Case

  alias HearthstoneLogic.User
  alias HearthstoneLogic.UserSupervisor

  setup do
    random_name = create_random_name()

    {:ok, pid} = UserSupervisor.start_child(random_name)

    %{name: random_name, pid: pid}
  end

  defp create_random_name() do
    "abcdefghijklmnoprstuvz"
    |> String.split("", trim: true)
    |> Enum.shuffle()
    |> Enum.take(Enum.random(5..10))
    |> Enum.join()
  end

  defp create_card() do
    Enum.random(1..2164)
  end

  describe "api `get_deck/1` " do
    test "user is still pending" do
      {:ok, pid} = User.start_link("name")
      assert :pending == :sys.get_state(pid).status
    end

    test "return empty deck", %{name: name} do
      send(String.to_atom(name), :find_user)
      assert [] == User.get_deck(name)
    end

    test "should add card to deck", %{name: name, pid: pid} do
      card = create_card()
      User.add_card_to_deck(name, card)
      assert [card] == User.get_deck(name)
      assert :syncing == :sys.get_state(pid).status
    end

    test "add two identical cards into deck", %{name: name} do
      card = create_card()
      User.add_card_to_deck(name, card)
      User.add_card_to_deck(name, card)
      assert [card, card] == User.get_deck(name)
    end

    test "remove a card from deck", %{name: name, pid: pid} do
      card = create_card()
      User.add_card_to_deck(name, card)
      User.remove_card_from_deck(name, card)
      assert [] == User.get_deck(name)
      assert :syncing == :sys.get_state(pid).status
    end

    test "try to remove non-existing card in deck", %{name: name} do
      Enum.each(1..10, fn _ -> User.add_card_to_deck(name, create_card()) end)
      assert {:error, :card_not_present} == User.remove_card_from_deck(name, 99999)
    end

    test "limit of deck size reached", %{name: name} do
      Enum.each(1..10, fn _ -> User.add_card_to_deck(name, create_card()) end)
      assert {:error, :deck_limit} == User.add_card_to_deck(name, create_card())
    end

    test "limit of identical cards", %{name: name} do
      card = create_card()
      Enum.each(1..3, fn _ -> User.add_card_to_deck(name, card) end)
      assert {:error, :card_limit} == User.add_card_to_deck(name, card)
    end

    test "limit of identical cards plus one new card", %{name: name} do
      card = create_card()
      Enum.each(1..4, fn _ -> User.add_card_to_deck(name, card) end)
      new_card = create_card()
      User.add_card_to_deck(name, new_card)
      assert 4 == length(User.get_deck(name))
    end
  end
end
