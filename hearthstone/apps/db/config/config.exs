use Mix.Config

config :db, Db.Repo,
  database: "dev",
  username: "zan",
  password: "zan",
  hostname: "localhost"

config :db, ecto_repos: [Db.Repo]
