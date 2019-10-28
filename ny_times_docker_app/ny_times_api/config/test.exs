use Mix.Config

config :ny_times_api, NyTimesApi.Repo,
  database: "dev",
  username: "devmaster",
  password: "masterpass",
  hostname: "localhost"

config :ny_times_api, ecto_repos: [NyTimesApi.Repo]