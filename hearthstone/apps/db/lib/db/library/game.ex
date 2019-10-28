defmodule Db.Library.Game do
  use Ecto.Schema

  alias Db.Library.User
  alias Db.Library.Round

  schema "games" do
    field(:name, :string)
    has_many(:rounds, Round)
    has_many(:users, User)
  end
end
