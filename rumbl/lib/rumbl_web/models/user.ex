defmodule RumblWeb.User do
    use RumblWeb, :model

    def changeset(model, params \\ :empty) do
        model
        
    end

    schema "users" do
        field :name, :string
        field :username, :string
        field :password, :string, virtual: true
        field :password_hash, :string

        timestamps
    end
end