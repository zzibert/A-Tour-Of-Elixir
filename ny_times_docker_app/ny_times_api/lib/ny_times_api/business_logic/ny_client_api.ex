defmodule NyTimesApi.BusinessLogic.ClientApi do
  @base_url "https://api.nytimes.com/svc"
  @api_key "NWPb2awjF7yNxR31knzrEl39m1fChAgW"

  def get_topstories(topic) do
    call(@base_url <> "/topstories/v2/#{topic}.json?")
  end

  def get_books(genre, date \\ get_date()) do
    call(@base_url <> "/books/v3/lists.json?list=#{genre}&date=#{date}&")
  end

  def get_book_review(book_name, date \\ get_date()) do
    IO.puts "CLIENT GET BOOK REVIEW"
    call(@base_url <> "/books/v3/reviews.json?title=#{book_name}&date=#{date}&")
  end

  def call(url) do
    (url <> "api-key=#{@api_key}")
    |> HTTPoison.get()
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code >= 200 and code < 300 ->
        IO.puts "OK CALL"
        {:ok, body}

      _ ->
        IO.puts "NOT OK CALL"
        {:error, :response_invalid}
    end
  end

  defp get_date do
    Timex.today() |> to_string()
  end
end
