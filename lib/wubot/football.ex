defmodule Football do
  def handle_argument(argument) do
    {command, parameter} = split_argument(argument)

    case command do
      "leagues" ->
        league_list()

      "help" ->
        help()

      "seasons" -> league_seasons_list(parameter)

      _ -> get_season(command, parameter)
    end
  end

  defp split_argument(argument) do
    if String.contains?(argument, " ") do
      split_result = String.split(argument, " ", parts: 2)
      {Enum.fetch!(split_result, 0), Enum.fetch!(split_result, 1)}
    else
      {argument, "No ARG"}
    end
  end

  defp help do
    "**Football Command List**\n\n" <>
      Enum.join(["`leagues`", "`seasons [leagueId]`", "`[leagueId] [year]`"], "\n")
  end

  defp league_list do
    http_response = HTTPoison.get!("https://api-football-standings.azharimm.site/leagues")
    {:ok, http_data} = Poison.decode(http_response.body)

    if http_data["status"] do
      leagues_list = http_data["data"]

      league_format_list =
        Enum.map(leagues_list, fn league ->
          "**#{league["name"]}**\n *Search ID*: #{league["id"]}\n *Abbreviation*: #{league["abbr"]}\n"
        end)

      "**League List**\n\n" <> Enum.join(league_format_list, "\n")
    end
  end

  defp league_seasons_list(league) do
    http_response =
      HTTPoison.get!("https://api-football-standings.azharimm.site/leagues/#{league}/seasons")

    {:ok, http_data} = Poison.decode(http_response.body)

    if http_data["status"] do
      seasons_list =
        http_data["data"]["seasons"]
        |> Enum.map(fn season -> "**#{season["year"]}**: #{season["displayName"]}\n" end)

      "**Seasons List**\n\n" <> Enum.join(seasons_list, "\n")
    else
      "Unknown league please use `!football leagues` to see available options. Remember to use their *Search Id*."
    end
  end

  defp get_season(league, season) do
    if season == "No ARG" do
      "Please provide a year"
    else
      http_response =
        HTTPoison.get!(
          "https://api-football-standings.azharimm.site/leagues/#{league}/standings?season=#{season}"
        )

        {:ok, http_data} = Poison.decode(http_response.body)

        if http_data["status"] do
          league_name = http_data["data"]["name"]
          league_year = http_data["data"]["seasonDisplay"]
          league_standings = Enum.with_index(http_data["data"]["standings"])

          standings_format_list =
            Enum.map(league_standings, fn {team, index} ->
              "#{index + 1}. **#{team["team"]["displayName"]}** (#{team["team"]["abbreviation"]})"
            end)

          "**#{league_name} #{league_year}**\n\n" <> Enum.join(standings_format_list, "\n")
        else
          "Please use `!football leagues` to check if the *Search Id* is correct or use `!football seasons [league id]` to make sure the year provided is available."
        end
    end
  end
end
