defmodule Math.MathTest do
  use ExUnit.Case
  alias Math.Math

  test "sum of empty list is 0" do
    assert Math.sum([]) == 0
  end
  
  test "random sums" do
    assert Math.sum([1, 3]) == 4
    assert Math.sum([1, 2, 3]) == 6
    assert Math.sum([1, 3, 5]) == 9
    assert Math.sum([3, 3]) == 6
    assert_raise(ArithmeticError, fn ->
      Math.sum([1, "test", 3])
    end)
    assert Math.sum([1, 2, 3, 4, 0x1F, 3,54,32,3]) == 133
  end
end

