defmodule TaskProjectTest do
  use ExUnit.Case
  doctest TaskProject

  test "greets the world" do
    assert TaskProject.hello() == :world
  end
end
