defmodule ScyllaTest do
  use ExUnit.Case
  doctest Scylla

  test "greets the world" do
    assert Scylla.hello() == :world
  end
end
