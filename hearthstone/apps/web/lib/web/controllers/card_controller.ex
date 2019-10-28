defmodule Web.CardController do
  use Web, :controller

  alias HearthstoneLogic.CardWorker

  def index(conn, _params) do
    render(conn, "card.html",
      cards: Enum.sort(CardWorker.get_cards(), &(&1.name < &2.name))
    )
  end
end
