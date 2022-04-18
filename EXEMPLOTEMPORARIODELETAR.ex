defmodule Testebot.Consumer do
  use Nostrum.Consumer
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  defp send_message_to_channel(text, channel_id) do
    Api.create_message(channel_id, text)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    channel_id = msg.channel_id
    content = msg.content

    cond do
      msg.content == "oi" ->
        send_message_to_channel("eae meu chapa", channel_id)

      msg.content in ["alou", "alo"] ->
        send_message_to_channel("aloooou", channel_id)

      msg.content == "mopa" ->
        send_message_to_channel("meu pau na tua boca!", channel_id)

      String.starts_with?(content, "ppt ") ->
        play_rock_paper_scissors(msg)

      String.starts_with?(content, "ppt") ->
        send_message_to_channel("use ppt seguido de pedra, papel ou tesoura", channel_id)

      String.starts_with?(content, "!weather ") ->
        handle_weather(msg)

      String.starts_with?(content, "!weather") ->
        send_message_to_channel("use !weather seguido de uma cidade", channel_id)

      true ->
        :ignore
    end
  end

  def durao() do
    IO.puts("kkk")
  end


  def handle_event(_event) do
    :noop
  end

  def handle_weather(msg) do
    city = Enum.fetch!(String.split(msg.content, " ", parts: 2), 1)
    send_message_to_channel("", msg.channel_id)

    htpp_response =
      HTTPoison.get!(
        "https://api.openweathermap.org/data/2.5/weather?q=#{city}&units=metric&lang=pt_br&appid=1cf226ea1900a705f1730ef79053e451"
      )

    {:ok, weather_data} = Poison.decode(htpp_response.body)

    channel_id = msg.channel_id

    case weather_data["cod"] do
      200 ->
        temperature = weather_data["main"]["temp"]
        send_message_to_channel("A temperatura em #{city} é de #{temperature} °C", channel_id)

      "404" ->
        send_message_to_channel("Não há informações sobre #{city}", channel_id)
    end
  end

  defp player_choice_to_int(choice) do
    case choice do
      "pedra" -> 0
      "papel" -> 1
      "tesoura" -> 2
      _ -> -99
    end
  end

  defp int_to_choice(int) do
    case int do
      0 -> "pedra"
      1 -> "papel"
      2 -> "tesoura"
      _ -> -99
    end
  end

  defp rock_paper_scissors_winner(player, bot) do
    match_result = player - bot

    cond do
      match_result == 0 -> "Empate."
      match_result in [1, -2] -> "Você ganhou!"
      match_result in [2, -1] -> "Bot ganhou!"
      true -> "Use pedra, papel ou tesoura."
    end
  end

  defp play_rock_paper_scissors(msg) do
    player_choice = Enum.fetch!(String.split(msg.content), 1)

    player_int = player_choice_to_int(player_choice)
    bot_int = Enum.random(0..2)

    winner_message = rock_paper_scissors_winner(player_int, bot_int)

    send_message_to_channel(
      "#{winner_message} #{player_choice} x #{int_to_choice(bot_int)}",
      msg.channel_id
    )
  end
end
