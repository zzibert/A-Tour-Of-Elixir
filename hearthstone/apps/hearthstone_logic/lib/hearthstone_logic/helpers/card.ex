defmodule HearthstoneLogic.Helpers.Card do
  @moduledoc """

  """

  alias Db.Library

  def upsert(nil) do
  end

  def upsert(card) do
    cond do
      is_nil(card["name"]) ->
        nil

      true ->
        case Library.does_card_exist?(card["name"]) do
          true ->
            old_card = Library.get_card_by_name!(card["name"])

            Library.Card.changeset(old_card, card)
            |> Library.update_card()

          false ->
            %Library.Card{}
            |> Library.Card.changeset(card)
            |> Library.insert_card()
        end
    end
  end
end
