defmodule Friends.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
  end


  def changeset(struct, params) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end
end
