defmodule DeckOfCardsTest do
  use ExUnit.Case
  doctest DeckOfCards

  test "greets the world" do
    assert DeckOfCards.hello() == :world
  end
end
