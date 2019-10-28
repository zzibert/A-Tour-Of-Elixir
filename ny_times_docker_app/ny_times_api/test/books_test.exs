defmodule NyTimesApi.Test.Book do
  use ExUnit.Case
  alias NyTimesApi.BusinessLogic.Books

  test "checking author_full_name function" do
    assert Books.author_full_name("dfdf dfdf dfdfd dfdf") == ["unknown", "unknown"]
    assert Books.author_full_name("Martin C. Fowler") == ["MARTIN", "FOWLER"]
    assert Books.author_full_name("") == ["unknown", "unknown"]
    assert Books.author_full_name("BY Martin Heidegger") == ["MARTIN", "HEIDEGGER"]
    assert Books.author_full_name("by Mark Zuckerberg") == ["MARK", "ZUCKERBERG"]
    assert Books.author_full_name("by johann sebastian bach") == ["JOHANN", "BACH"]
  end

  test "checking get_books function" do
    
  end
end
