defmodule Math.LetterCountTest do
  use ExUnit.Case
  alias Math.LetterCount

  test "words" do
    assert 3 == LetterCount.word("anana", "a")
    assert 0 == LetterCount.word("nana", "k")
    assert 3 == LetterCount.word("Anana", "a")
  end
end