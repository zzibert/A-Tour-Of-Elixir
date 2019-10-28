defmodule CounterTest do
  use ExUnit.Case

  alias StartProject.{CounterSupervisor, Counter}

  test "Let's see if the counting is right" do
    CounterSupervisor.greetings("zan")
    CounterSupervisor.greetings("miha")
    CounterSupervisor.greetings("lovro")

    Counter.greetings("lovro")
    Counter.greetings("zan")
    Counter.greetings("miha")
    Counter.greetings("lovro")
    Counter.greetings("miha")
    Counter.greetings("lovro")

    assert "Hello, zan was called 2 times" == Counter.greetings("zan")
    assert "Hello, miha was called 3 times" == Counter.greetings("miha")
    assert "Hello, lovro was called 4 times" == Counter.greetings("lovro")
  end
end
