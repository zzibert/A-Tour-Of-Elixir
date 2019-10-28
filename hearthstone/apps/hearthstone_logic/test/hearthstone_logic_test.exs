defmodule HearthstoneLogicTest do
  use ExUnit.Case
  doctest HearthstoneLogic

  test "greets the world" do
    assert HearthstoneLogic.hello() == :world
  end
end
