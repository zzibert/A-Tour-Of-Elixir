defmodule SolarTest do
  use ExUnit.Case
  use Timex

  setup do
    flares = [
      %{classification: :X, scale: 99, date: {1859, 8, 29}},
      %{classification: :M, scale: 5.8, date: {2015, 1, 12}},
      %{classification: :C, scale: 3.2, date: {2015, 4, 18}}
    ]

    {:ok, data: flares}
  end

  test "we have 3 solar flares", %{data: flares} do
    assert length(flares) == 3
  end

  test "Go inside", %{data: flares} do
    d = Solar.no_eva(flares)
    assert length(d) == 1
  end

  test "Deadliest", %{data: flares} do
    d = Solar.deadliest(flares)
    assert d == 99000
  end
end
