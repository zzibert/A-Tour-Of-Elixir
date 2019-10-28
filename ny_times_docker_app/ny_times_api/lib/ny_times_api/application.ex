defmodule NyTimesApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec

  def start(_type, _args) do
    # genre_list = ["hardcover-fiction", "hardcover-nonfiction"]

    children = [
      supervisor(NyTimesApi.Repo, []),
      supervisor(NyTimesApi.BusinessLogic.NewsBySegmentSupervisor, []),
      supervisor(NyTimesApi.BusinessLogic.BooksSupervisor, [])
    ]

    # ++ Enum.map(genre_list, &worker(NyTimesApi.BookZiga, [&1], id: String.to_atom(&1)))

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NyTimesApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
