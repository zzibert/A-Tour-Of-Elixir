defmodule Math.Fibonacci do
  def get(n) when n < 2  do
    1
  end

  def get(n) do
    get(n - 1) + get(n - 2)
  end
end

defmodule Math.LetterCount do
  def word("", _) do
    0
  end

  def word(word, letter)  do


    [head | tail] = word |> String.downcase |> String.graphemes

    if head == String.downcase(letter) do
      1 + word(List.to_string(tail), head)
    else
      word(List.to_string(tail), letter)
    end
  end
end

defmodule Math.Math do
  def sum([]) do
    0
  end

  def sum([ head | tail]) do
    head + sum(tail)
  end
end
