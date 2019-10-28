defmodule Kafka.Producer.CardProcessing do
  def produce_call(topic, partition, payload) do
    Producer.produce_call("worker", topic, partition, payload)
  end

  def produce_cast(topic, partition, payload) do
    Producer.produce_cast("worker", topic, partition, payload)
  end
end
