defmodule Scylla.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec

  #######
  # API #
  #######
  def start(_type, _args) do
    keyspace = Application.get_env(:scylla, :scylla_keyspace)

    children = [
      worker(Xandra, [
        Application.get_env(:xandra, Xandra) ++
          [after_connect: fn conn -> Xandra.execute(conn, keyspace) end]
      ])
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  def stop(_state) do
    :lager.log(:info, self(), "[#{__MODULE__}] Receive shutdown callback")
  end

  #############
  # CALLBACKS #
  #############

  #####################
  # PRIVATE FUNCTIONS #
  #####################
end
