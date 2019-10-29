defmodule BmwUmbrella.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :token, :string
    field :vin, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :vin, :token])
    |> validate_required([:email, :vin, :token])
    |> unique_constraint(:email)
    |> unique_constraint(:vin)
    |> unique_constraint(:token)
  end
end
