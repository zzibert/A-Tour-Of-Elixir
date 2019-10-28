{:ok, connection} = AMQP.Connection.open
{:ok, channel} = AMQP.Channel.open(connection)

AMQP.Queue.declare(channel, "hello")

AMQP.Basic.consume(channel, "hello", nil, no_ack: true)

defmodule Receive do
  def wait_for_messages do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts " [x] Received #{payload}"
        wait_for_messages()
    end
  end
end

IO.puts " [*] Waiting for messages."
Receive.wait_for_messages()