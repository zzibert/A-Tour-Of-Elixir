defmodule Kafka.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Kafka.Consumer
  alias Kafka.Producer

  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(
        KafkaEx.ConsumerGroup,
        [
          Consumer,
          "test_consumer_group",
          ["cards"],
          [
            heartbeat_interval: 1_000,
            commit_interval: 1_000,
            auto_offset_reset: :earliest
          ]
        ],
        id: String.to_atom("cards_id")
      ),
      worker(Producer, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kafka.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
