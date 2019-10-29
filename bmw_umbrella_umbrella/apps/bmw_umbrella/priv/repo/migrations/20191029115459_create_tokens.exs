defmodule BmwUmbrella.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :value, :string

      timestamps()
    end

    create unique_index(:tokens, [:value])
  end
end
