defmodule Solar do

  def power(%{classification: :M, scale: s}), do: s * 10
  def power(%{classification: :X, scale: s}), do: s * 1000
  def power(%{classification: :C, scale: s}), do: s

  def no_eva(flares), do: Enum.filter flares, &(power(&1) > 1000)

  def deadliest(flares) do
    Enum.map(flares, &(power(&1)))
    |> Enum.max
  end

  def flare_list(flares) do
    for flare <- flares, do: %{power: power(flare), is_deadl: power(flare) > 1000}
  end

  def total_flare_power(flares), do: total_flare_power(flares, 0)

  def total_flare_power([], sum), do: sum

  def total_flare_power([head | tail], sum) do
    total_flare_power(tail, sum + power(head))
  end
end