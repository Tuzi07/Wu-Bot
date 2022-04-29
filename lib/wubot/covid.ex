defmodule Covid do
  def handle_argument(argument) do
    {command, param} = split_argument(argument)

    case command do
      "help" -> help()
      "countries" -> country_list(String.to_integer(param))
      "deaths" -> deaths(param)
    end
  end

  defp split_argument(argument) do
    if String.contains?(argument, " ") do
      split_result = String.split(argument, " ", parts: 2)
      {Enum.fetch!(split_result, 0), Enum.fetch!(split_result, 1)}
    else
      if argument == "countries" do
        {argument, 0}
      else
        {argument, "World"}
      end
    end
  end

  defp help do
    "**Covid Command Help**\n\n`countries`\n`deaths [country name]`\n`cases [country name]`\n`recovered [country name]`\n***Country name* is optional. Provide no country to see *world* stats**"
  end

  defp country_list(page) do
    if page != 0 do
      http_response = HTTPoison.get!("https://covid-19.dataflowkit.com/v1")
      {:ok, data_list} = Poison.decode(http_response.body)

      list_index = page-1
      page_count = 10
      page_length = Integer.floor_div(length(data_list), page_count)
      pages_list = Enum.chunk_every(data_list, page_length)

      country_page_list = Enum.at(pages_list, list_index)

      country_names = Enum.map(country_page_list, fn country -> country["Country_text"] end)
      "**Country List Page #{page}**\n\n" <> Enum.join(country_names, "\n")
    else
      "Please provide a page number. [1-10]"
    end
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
