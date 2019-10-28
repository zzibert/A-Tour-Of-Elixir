defmodule Db.Library.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Db.Library.Game

  schema "users" do
    field(:name, :string)
    field(:deck, {:array, :integer})
    belongs_to(:game, Game)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :deck])
    |> validate_length(:name, min: 3, max: 20)
    |> validate_length(:deck, max: 10)
    |> unique_constraint(:name)
  end
end
