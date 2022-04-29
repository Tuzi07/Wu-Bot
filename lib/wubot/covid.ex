defmodule Covid do
  def handle_argument(argument) do
    {command, country} = split_argument(argument)

    case command do
      "help" -> help()
      "countries" -> country_list()
      "deaths" -> deaths(country)
    end
  end

  defp split_argument(argument) do
    if String.contains?(argument, " ") do
      split_result = String.split(argument, " ", parts: 2)
      {Enum.fetch!(split_result, 0), Enum.fetch!(split_result, 1)}
    else
      {argument, "World"}
    end
  end

  defp help do
    "**Covid Command Help**\n\n`countries`\n`deaths [country name]`\n`cases [country name]`\n`recovered [country name]`\n***Country name* is optional. Provide no country to see *world* stats**"
  end

  defp country_list do
    http_response = HTTPoison.get!("https://covid-19.dataflowkit.com/v1")
    IO.puts("countries")
    {:ok, data_list} = Poison.decode(http_response.body)

    country_names = Enum.map(data_list, fn country -> country["Country_text"] end)
    IO.puts("sending message")
    "**Country List**\n\n" <> Enum.join(country_names, "\n")
  end

  defp deaths(country) do
    http_response = HTTPoison.get!("https://covid-19.dataflowkit.com/v1/#{country}")

    {:ok, country_data} = Poison.decode(http_response.body)

    if verify_search_success(country, country_data["Country_text"]) do
      "**#{country_data["Country_text"]} Deaths**\n\n***Last Update:*** #{country_data["Last Update"]}\n***New Deaths:*** #{country_data["New Deaths_text"]}\n***Total Deaths:*** #{country_data["Total Deaths_text"]}"
    else
      "I do not seem to recognize that country. Use `!covid countries`to see available ones."
    end
  end

  defp verify_search_success(country, data_received) do
    String.downcase(data_received) == String.downcase(country)
  end
end
