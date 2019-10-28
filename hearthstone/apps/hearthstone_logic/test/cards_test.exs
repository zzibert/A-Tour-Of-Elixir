defmodule CardTest do
  @moduledoc """
  1.) Test if card insert itself with Busness logic
  2.) If card has param which should be present but it isn't, card shouldn't be inserted
  3.) If card has parameter parameter that should be updated, param should be updated
  4.) Card should only be in DB once
  """
  use ExUnit.Case

  alias Db.Library

  alias HearthstoneLogic.Helpers.Card

  setup do
    random_name =
      "abcdefghijklmnoprstuvz"
      |> String.split("", trim: true)
      |> Enum.shuffle()
      |> Enum.take(Enum.random(5..10))
      |> Enum.join()

    card = %{
      "name" => random_name,
      "text" => nil,
      "attack" => 140,
      "class" => "DRUID",
      "cost" => 234,
      "health" => 1500,
      "type" => "MINION",
      "rarity" => "LEGENDARY"
    }

    %{card: card}
  end

  describe "function `insert_card/1`" do
    test "should be insert card", %{card: card} do
      Card.upsert(card)
      assert true == Library.does_card_exist?(card["name"])
    end

    test "card should not be inserted", %{card: card} do
      Card.upsert(card)
      assert
    end

    test "should update if new parmas", %{card: card} do
      Card.upsert(card)

      card
      |> Map.put("cost", 250)
      |> Card.upsert()

      assert 250 ==
               card["name"]
               |> Library.get_card_by_name!()
               |> Map.get(:cost)

      IO.inspect(Library.get_card_by_name!(card["name"]))
    end

    test "should update if new parameters 2", %{card: card} do
      Card.upsert(card)

      card
      |> Map.put("text", "trololo")
      |> Map.put("health", 10000)
      |> Card.upsert()

      assert "trololo" ==
               card["name"]
               |> Library.get_card_by_name!()
               |> Map.get(:text)

      assert 10000 ==
               card["name"]
               |> Library.get_card_by_name!()
               |> Map.get(:health)
    end

    test "only one card should be inserted", %{card: card} do
      Card.upsert(card)
      Card.upsert(card)

      assert 1 ==
               Library.get_all_cards!()
               |> Enum.filter(&(&1.name == card["name"]))
               |> Enum.count()
    end

    test "only one card is in state", %{card: card} do
      Card.upsert(card)
      Card.upsert(card)
      Card.upsert(card)
      Card.upsert(card)
      Card.upsert(card)

      assert 1 == length(Library.get_all_cards!())
    end
  end
end
