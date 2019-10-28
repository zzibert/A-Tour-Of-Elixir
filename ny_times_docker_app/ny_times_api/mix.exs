defmodule NyTimesApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :ny_times_api,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :poison, :timex, :ecto],
      mod: {NyTimesApi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.5"},
      {:poison, "~> 4.0"},
      {:timex, "~> 3.6"},
      {:ecto, "~> 3.1"},
      {:postgrex, "~> 0.15.0"},
      {:ecto_sql, "~> 3.1"}
    ]
  end
end
