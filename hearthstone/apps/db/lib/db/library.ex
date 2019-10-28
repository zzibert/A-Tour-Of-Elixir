defmodule Db.Library do
  import Ecto.Query

  alias Db.Library.{Card, Deck, User}
  alias Db.Repo

  # CARDS #

  def get_all_cards!() do
    Repo.all(Card)
  end

  def does_card_exist?(card_name) do
    Card
    |> where([c], c.name == ^card_name)
    |> select([c], count(c.id) > 0)
    |> Repo.one()
  end

  def get_card_by_name!(card_name) do
    Card
    |> where([c], c.name == ^card_name)
    |> Repo.one()
  end

  def get_card_by_id!(id) do
    Card
    |> where([c], c.id == ^id)
    |> Repo.one()
  end

  def update_card(changeset) do
    Repo.update!(changeset)
  end

  def insert_card(changeset) do
    Repo.insert!(changeset)
  end

  def delete_card(changeset) do
    Repo.delete(changeset)
  end

  # USERS #

  def create_user(changeset) do
    Repo.insert!(changeset)
  end

  def update_user(changeset) do
    Repo.update!(changeset)
  end

  def get_all_users!() do
    Repo.all(User)
  end

  def get_user_by_name!(user_name) do
    User
    |> where([u], u.name == ^user_name)
    |> Repo.one()
  end

  def does_user_exist?(user_name) do
    User
    |> where([u], u.name == ^user_name)
    |> select([u], count(u.id) > 0)
    |> Repo.one()
  end
end
