defmodule BmwUmbrella.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias BmwUmbrella.Repo

  alias BmwUmbrella.Auth.User
  alias BmwUmbrella.Auth.Token

 # USERS ""
  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

# TOKENS #

  def list_tokens do
    Repo.all(Token)
  end

  def get_token!(id), do: Repo.get!(Token, id)

  def get_token_by_value!(value) do
    Token
    |> where([t], t.value == ^value)
    |> Repo.one()
  end

  def create_token(attrs \\ %{}) do
    %Token{}
    |> Token.changeset(attrs)
    |> Repo.insert()
  end

  def update_token(%Token{} = token, attrs) do
    token
    |> Token.changeset(attrs)
    |> Repo.update()
  end

  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  def change_token(%Token{} = token) do
    Token.changeset(token, %{})
  end

end
