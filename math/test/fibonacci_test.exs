defmodule Math.FibonacciTest do
  use ExUnit.Case
  alias Math.Fibonacci

  test "first fibonacci" do
    assert Fibonacci.get(0) == 1
    assert Fibonacci.get(1) == 1
  end

  test "random fibonaccis" do
    assert  Fibonacci.get(2) == 2
    assert  Fibonacci.get(3) == 3
    assert  Fibonacci.get(4) == 5
    assert  Fibonacci.get(5) == 8
    assert  Fibonacci.get(25) == 121393
    assert  Fibonacci.get(17) == 2584
    assert  Fibonacci.get(13) == 377
  end
end



