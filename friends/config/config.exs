use Mix.Config

config :friends, Friends.Repo,
  database: "postgres",
  username: "postgres",
  password: "nekineki",
  hostname: "localhost"

  config :friends, ecto_repos: [Friends.Repo]
