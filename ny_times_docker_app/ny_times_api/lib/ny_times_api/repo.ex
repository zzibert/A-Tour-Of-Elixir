defmodule NyTimesApi.Repo do
  use Ecto.Repo,
    otp_app: :ny_times_api,
    adapter: Ecto.Adapters.Postgres
end
