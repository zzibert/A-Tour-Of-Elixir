use Mix.Config

config :ny_times_api, NyTimesApi.Repo,
  database: System.get_env("POSTGRES_DB"),
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("POSTGRES_HOST")

config :ny_times_api, ecto_repos: [NyTimesApi.Repo]