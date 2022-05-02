defmodule WuBot.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    channel_id = msg.channel_id
    content = msg.content

    cond do
      content == "!help" ->
        send_message_to_discord_channel(Help.help_message(), channel_id)

      String.starts_with?(content, "!fruit") ->
        send_message_to_discord_channel(
          Fruits.handle_argument(command_argument(content)),
          channel_id
        )

      content == "!programmingquote" ->
        send_message_to_discord_channel(ProgrammingQuote.random_quote(), channel_id)

      content == "!bible" ->
        send_message_to_discord_channel(Bible.random_quote(), channel_id)

      String.starts_with?(content, "!football") ->
        send_message_to_discord_channel(
          Football.handle_argument(command_argument(content)),
          channel_id
        )

      String.starts_with?(content, "!crypto") ->
        send_message_to_discord_channel(
          CryptoCurrency.handle_argument(command_argument(content)),
          channel_id
        )

      String.starts_with?(content, "!password") ->
        send_message_to_discord_channel(
          Password.argument_handler(command_argument(content)),
          channel_id
        )

      String.starts_with?(content, "!covid") ->
        send_message_to_discord_channel(
          Covid.handle_argument(command_argument(content)),
          channel_id
        )

      content == "!fox" ->
        send_message_to_discord_channel(Fox.image(), channel_id)

      String.starts_with?(content, "!programmingcontest") ->
        send_message_to_discord_channel(
          ProgrammingContest.handle_argument(command_argument(content)),
          channel_id
        )

      String.starts_with?(content, "!iseven") ->
        send_message_to_discord_channel(
          IsEven.handle_argument(command_argument(content)),
          channel_id
        )

      true ->
        :ignore
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

  defp command_argument(command) do
    if String.contains?(command, " ") do
      Enum.fetch!(String.split(command, " ", parts: 2), 1)
    else
      "help"
    end
  end
end
