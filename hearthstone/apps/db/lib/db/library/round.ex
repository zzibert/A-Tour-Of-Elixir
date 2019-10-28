defmodule Db.Library.Round do
  use Ecto.Schema

  alias Db.Library.Game

  schema "rounds" do
    field(:users, :string)
    field(:action, :string)
    belongs_to(:game, Game)
  end
end
