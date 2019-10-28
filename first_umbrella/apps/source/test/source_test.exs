defmodule SourceTest do
  use ExUnit.Case
  doctest Source

  test "greets the world" do
    assert Source.hello() == :world
  end
end
