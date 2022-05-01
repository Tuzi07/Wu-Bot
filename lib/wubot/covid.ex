defmodule Covid do
  def handle_argument(argument) do
    {command, param} = split_argument(argument)

    case command do
      "help" -> help()
      "countries" -> country_list(String.to_integer(param))
      "deaths" -> deaths(param)
      "cases" -> cases(param)
      "recovered" -> recovered(param)
      "active" -> active(param)
    end
  end

  defp split_argument(argument) do
    if String.contains?(argument, " ") do
      split_result = String.split(argument, " ", parts: 2)
      {Enum.fetch!(split_result, 0), Enum.fetch!(split_result, 1)}
    else
      if argument === "countries" do
        {argument, "0"}
      else
        {argument, "World"}
      end
    end
  end

  defp help do
    "**Covid Command Help**\n\n`countries`\n`deaths [country name]`\n`cases [country name]`\n`recovered [country name]`\n***Country name* is optional. Provide no country to see *world* stats**"
  end

  defp country_list(page) do
    if page in 1..10 do
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
      message_formatter(country_data, "Deaths")
    else
      "I do not seem to recognize that country. Use `!covid countries` to see available ones."
    end
  end

  defp cases(country) do
    http_response = HTTPoison.get!("https://covid-19.dataflowkit.com/v1/#{country}")

    {:ok, country_data} = Poison.decode(http_response.body)

    if verify_search_success(country, country_data["Country_text"]) do
      message_formatter(country_data, "Cases")
    else
      "I do not seem to recognize that country. Use `!covid countries` to see available ones."
    end
  end

  defp recovered(country) do
    http_response = HTTPoison.get!("https://covid-19.dataflowkit.com/v1/#{country}")

    {:ok, country_data} = Poison.decode(http_response.body)

    if verify_search_success(country, country_data["Country_text"]) do
      "**#{country_data["Country_text"]} Recovered**\n\n***Last Update:*** #{country_data["Last Update"]} GMT\n***Total Recovered:*** #{country_data["Total Recovered_text"]}"
    else
      "I do not seem to recognize that country. Use `!covid countries` to see available ones."
    end
  end

  defp active(country) do
    http_response = HTTPoison.get!("https://covid-19.dataflowkit.com/v1/#{country}")

    {:ok, country_data} = Poison.decode(http_response.body)

    if verify_search_success(country, country_data["Country_text"]) do
      "**#{country_data["Country_text"]} Active Cases**\n\n***Last Update:*** #{country_data["Last Update"]} GMT\n***Active Cases:*** #{country_data["Active Cases_text"]}"
    else
      "I do not seem to recognize that country. Use `!covid countries` to see available ones."
    end
  end

  defp verify_search_success(country, data_received) do
    String.downcase(data_received) == String.downcase(country)
  end

  defp message_formatter(country_data, command) do
    "**#{country_data["Country_text"]} #{command}**\n\n***Last Update:*** #{country_data["Last Update"]} GMT\n***New #{command}:*** #{country_data["New #{command}_text"]}\n***Total #{command}:*** #{country_data["Total #{command}_text"]}"
  end
end
