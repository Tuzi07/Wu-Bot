defmodule WuBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    content = msg.content
    cond do
      content == "!sleep" ->
        send_message_to_discord_channel("Going to sleep..." ,msg.channel_id)
        # This won't stop other events from being handled.
        Process.sleep(3000)

      content == "!ping" ->
        send_message_to_discord_channel( "pyongyang!" ,msg.channel_id)

      content == "!raise" ->
        # This won't crash the entire Consumer.
        raise "No problems here!"

      content == "!fruit" ->
        IO.puts(msg)
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end

  defp send_message_to_discord_channel(text, channel_id) do
    Api.create_message(channel_id, text)
  end
end
