defmodule NyTimesApi.Db.News do
  import Ecto.Query

  alias NyTimesApi.Db.News.Story
  alias NyTimesApi.Db.News.Author
  alias NyTimesApi.Repo

  def get_story!(story_id) do
    Story
    |> where([s], s.id == ^story_id)
    |> Repo.one()
  end

  def get_stories do
    Story
    |> Repo.all()
  end

  def does_story_exist?(title) do
    Story
    |> where([s], s.title == ^title)
    |> Repo.one()
  end

  def insert_stories(news) do
    Repo.insert_all(Story, news)
  end

  def get_author!(id) do
    Author
    |> where([a], a.id == ^id)
    |> Repo.one()
  end

  def get_author_with_stories(id) do
    Repo.preload(get_author!(id), :stories)
  end

  def get_authors_with_stories do
    Repo.preload(get_authors(), :stories)
  end

  def get_authors do
    Repo.all(Author)
  end

  def does_author_exist?(first_name, last_name) do
    Author
    |> where([a], a.first_name == ^first_name and a.last_name == ^last_name)
    |> Repo.one()
  end

  def insert_author(first_name, last_name) do
    Repo.insert!(%Author{first_name: first_name, last_name: last_name})
  end
end
