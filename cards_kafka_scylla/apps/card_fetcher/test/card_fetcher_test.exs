defmodule CardFetcherTest do
  use ExUnit.Case
  doctest CardFetcher

  test "greets the world" do
    assert CardFetcher.hello() == :world
  end
end
