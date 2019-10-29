defmodule BmwUmbrella.Auth.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:value])
    |> validate_required([:value])
    |> unique_constraint(:value)
  end
end
