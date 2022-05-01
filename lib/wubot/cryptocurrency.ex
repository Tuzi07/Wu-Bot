defmodule CryptoCurrency do
  def handle_argument(argument) do
    case argument do
      "top10" ->
        top_10_crypto_message()

      "random" ->
        random_crypto_message()

      _ ->
        fetch_crypto_and_create_message(argument)
    end
  end

  defp top_10_crypto_message() do
    "**Top 10 Cryptocurrency by Market Cap**\n\n" <> top_10_crypto()
  end

  defp top_10_crypto() do
    crypto_data = coingecko_crypto_data()

    Enum.take(crypto_data, 10)
    |> Enum.map(fn coin -> "#{coin["market_cap_rank"]}. #{coin["id"]}" end)
    |> Enum.join("\n")
  end

  defp coingecko_crypto_data() do
    htpp_response =
      HTTPoison.get!(
        "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc"
      )

    {:ok, http_data} = Poison.decode(htpp_response.body)
    http_data
  end

  defp random_crypto_message() do
    crypto_data = coingecko_crypto_data()

    random_crypto = Enum.random(crypto_data)

    crypto_message_from_small_dataset(random_crypto)
  end

  defp crypto_message_from_small_dataset(small_dataset) do
    name = small_dataset["name"]
    symbol = small_dataset["symbol"]
    market_cap_rank = small_dataset["market_cap_rank"]
    market_cap = Number.Currency.number_to_currency(small_dataset["market_cap"])
    current_price = Number.Currency.number_to_currency(small_dataset["current_price"])

    crypto_message(name, symbol, market_cap_rank, market_cap, current_price)
  end

  defp crypto_message(name, symbol, market_cap_rank, market_cap, current_price) do
    "**#{name}** - #{symbol}\n\nMarket Cap Rank: ##{market_cap_rank}\nMarket Cap: #{market_cap}\nCurrent Price: #{current_price}"
  end

  defp fetch_crypto_and_create_message(argument) do
    http_data = fetch_crypto(argument)

    if http_data["error"] do
      "Invalid cryptocurrency id."
    else
      crypto_message_from_complete_dataset(http_data)
    end
  end

  defp fetch_crypto(argument) do
    htpp_response = HTTPoison.get!("https://api.coingecko.com/api/v3/coins/#{argument}")

    {:ok, http_data} = Poison.decode(htpp_response.body)
    http_data
  end

  defp crypto_message_from_complete_dataset(dataset) do
    name = dataset["name"]
    symbol = dataset["symbol"]
    market_cap_rank = dataset["market_cap_rank"]
    market_cap = Number.Currency.number_to_currency(dataset["market_data"]["market_cap"]["usd"])

    current_price =
      Number.Currency.number_to_currency(dataset["market_data"]["current_price"]["usd"])

    crypto_message(name, symbol, market_cap_rank, market_cap, current_price)
  end
end
