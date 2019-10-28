use Mix.Config

config :web,
  generators: [context_app: false]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aHOziDfrylbtt5HzMuVTNxWRPVaF8udNQPAS/oHcsoUIGRpqGdC8lTxs6cSBpqOb",
  render_errors: [view: Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2]

# config :db, Db.Repo,
#   database: "dev",
#   username: "zan",
#   password: "zan",
#   hostname: "localhost"

# config :db, ecto_repos: [Db.Repo]

import_config "#{Mix.env()}.exs"
