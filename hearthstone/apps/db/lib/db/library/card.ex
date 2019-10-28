defmodule Db.Library.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field(:name, :string)
    field(:text, :string)
    field(:flavor, :string)
    field(:attack, :integer)
    field(:class, :string)
    field(:cost, :integer)
    field(:health, :integer)
    field(:type, :string)
    field(:rarity, :string)
  end

  def changeset(card, params \\ %{}) do
    card
    |> cast(params, [:name, :text, :flavor, :attack, :class, :cost, :health, :type, :rarity])
    |> validate_required([:name, :attack])
    |> unique_constraint(:name)
  end
end
