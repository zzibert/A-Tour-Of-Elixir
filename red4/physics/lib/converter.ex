defmodule Converter do
  def to_nearest_tenth(val) do
    Float.ceil(val, 1)
  end

  def to_meters(length) do
    length * 1000
  end

  def to_km(velocity) do
    velocity / 1000
  end

  def to_light_seconds({:miles, miles}) do
    (miles * 5.36819e-6)
    |> round_down
  end

  def round_down(val) when is_float(val), do: trunc(val)

  def seconds_to_hours(seconds), do: seconds / 3600
end
