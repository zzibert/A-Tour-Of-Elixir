defmodule HearthstoneLogic.Helpers.User do
  alias Db.Library

  import Ecto.Query

  def number_of_identical_cards(card_id, deck) do
    Enum.count(deck, fn card -> card == card_id end)
  end

  def get_all_users!() do
    Library.get_all_users!()
  end

  def find_user(user_name) do
    case Library.get_user_by_name!(user_name) do
      nil ->
        %Library.User{}
        |> Library.User.changeset(%{name: user_name})
        |> Library.create_user()

      user ->
        user
    end
  end

  def update_user(%{name: name, deck: deck}) do
    name
    |> Library.get_user_by_name!()
    |> Library.User.changeset(%{name: name, deck: deck})
    |> Library.update_user()
  end

  def find_deck(user_name) do
    %{deck: deck} = find_user(user_name)

    case deck do
      nil ->
        []

      _ ->
        deck
    end
  end

  def save_deck(user_name, deck) do
  end
end
