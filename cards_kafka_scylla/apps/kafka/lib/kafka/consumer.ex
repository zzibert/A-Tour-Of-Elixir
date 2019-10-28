defmodule Kafka.Consumer do
  use KafkaEx.GenConsumer

  alias Kafka.MessageQueueHandler

  require Logger

  defmodule State do
    defstruct [:topic, :partition]
  end

  defmodule Card do
    defstruct name: "",
              attack: "",
              health: ""
  end

  defmodule CardAndTable do
    defstruct card: %Card{},
              table: ""
  end

  # CALLBACKS #

  def init(topic, partition) do
    Process.flag(:trap_exit, true)
    {:ok, %State{topic: topic, partition: partition}}
  end

  def handle_message_set(kafka_messages, %State{topic: topic} = state) do
    for %Message{value: message} <- kafka_messages do
      # decoded_message = Poison.decode!(message, as: %CardAndTable{})
      card = Poison.decode!(message, as: %Card{})
      # decoded = %CardAndTable{card: card, table: decoded_message.table}
      statement = "INSERT INTO cards_by_attack_and_health (name, attack, health) VALUES (?, ?, ?)"
      Xandra.execute!(:xandra, statement, [
        {"text", card.name},
        {"int", card.attack},
        {"int", card.health},
      ], pool: Xandra.Cluster)
      
      Logger.debug(fn -> "message: " <> inspect(card) end)
    end
    # MessageQueueHandler.handle(topic, kafka_messages)
    {:sync_commit, state}
  end
end
