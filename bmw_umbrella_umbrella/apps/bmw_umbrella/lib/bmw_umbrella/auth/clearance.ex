defmodule BmwUmbrella.Auth.Clearance do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "clearances" do
      field :clearance_id, :string
  
      timestamps()
    end
  
    @doc false
    def changeset(token, attrs) do
      token
      |> cast(attrs, [:id])
      |> validate_required([:id])
      |> unique_constraint(:id)
    end
  end