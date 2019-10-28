defmodule BmwUmbrella.Repo do
  use Ecto.Repo,
    otp_app: :bmw_umbrella,
    adapter: Ecto.Adapters.Postgres
end
