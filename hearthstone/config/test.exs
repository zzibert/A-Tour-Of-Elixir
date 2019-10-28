use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web, Web.Endpoint,
  http: [port: 4002],
  server: false

config :db, Db.Repo,
  database: "test",
  username: "zan",
  password: "zan",
  hostname: "localhost",
  pool_size: 15,
  pool: Ecto.Adapters.SQL.Sandbox

config :db, ecto_repos: [Db.Repo]
