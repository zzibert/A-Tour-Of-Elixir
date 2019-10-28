defmodule HearthstoneLogic.ClientApi do
  @all_cards_url "https://api.hearthstonejson.com/v1/33402/enUS/cards.json"

  def get_all_cards() do
    call(@all_cards_url)
  end

  def call(url) do
    url
    |> HTTPoison.get()
    |> case do
      {:ok, %HTTPoison.Response{status_code: code, body: body}}
      when code >= 200 and code <= 300 ->
        {:ok, body}

      _ ->
        {:error, :response_invalid}
    end
  end
end
