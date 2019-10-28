defmodule Kafka.MessageQueueHandler do

  alias KafkaEx.Protocol.Fetch.Message

  defmodule Card do
    defstruct name: "",
              attack: "",
              health: ""
  end

  defmodule Table do
    defstruct name: ""
  end

  defmodule CardAndTable do
    defstruct card: %Card{},
              table: %Table{}
  end

  # def get_all_cards() do
  #   statement = "SELECT * FROM cards"
  #   {:ok, %Xandra.Page{} = page} = Xandra.execute(:xandra, statement, [])
  # end

  def handle(topic, kafka_messages, table) do
    cond do
      topic =~ "cards" ->
        for %Message{value: message} <- kafka_messages do
          message_decoded = Poison.decode!(message)
          IO.inspect message_decoded
          # statement = "INSERT INTO #{message.table} (name, attack, health) VALUES (?, ?, ?)"
          # card = Poison.decode!(message.card, as: %Card{})
          # Xandra.execute!(:xandra, statement, [
          #   {"text", card.name},
          #   {"int", card.attack},
          #   {"int", card.health},
          # ], pool: Xandra.Cluster)
        end

      true ->
        :lager.log(:warning, self(), "[#{__MODULE__}] Wrong topic #{topic} to send!")
    end
  end
end
