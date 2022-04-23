defmodule Football do
  def handler(content) do
    try do
      command = Enum.fetch!(String.split(content, " ", parts: 2), 1)

      if String.contains?(command, " ") do
        Enum.fetch!(String.split(command, " ", parts: 2), 0)
      else
        if command == "seasons" do
          raise "No League Specified, please try !football seasons [League Search Id]"
        end

        command
      end
    rescue
      Enum.OutOfBoundsError ->
        "Please provide a second argument. Use !football help for command list"

      e in RuntimeError ->
        e.message
    else
      "leagues" ->
        league_list()

      "help" ->
        help()

      "seasons" ->
        Enum.fetch!(String.split(content, " ", parts: 2), 1) |> league_seasons_list()

      _ ->
        Enum.fetch!(String.split(content, " ", parts: 2), 1) |> get_season()
    end
  end

  defp help do
    "**Command List**\n\n" <> Enum.join(["leagues", "[leagueId]", "[leagueId] [year]"], "\n")
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

  defp league_seasons_list(command) do
    league = Enum.fetch!(String.split(command, " ", parts: 2), 1)

    http_response =
      HTTPoison.get!("https://api-football-standings.azharimm.site/leagues/#{league}/seasons")

    {:ok, http_data} = Poison.decode(http_response.body)

    if http_data["status"] do
      seasons_list =
        http_data["data"]["seasons"]
        |> Enum.map(fn season -> "**#{season["year"]}**: #{season["displayName"]}\n" end)

      "**Seasons List**\n\n" <> Enum.join(seasons_list, "\n")
    else
      "Unknown league please use !football leagues to see available options. Remember to use their Search Id."
    end
  end

  defp get_season(command) do
    try do
      Enum.fetch!(String.split(command, " ", parts: 2), 0)
      Enum.fetch!(String.split(command, " ", parts: 2), 1)
    rescue
      Enum.OutOfBoundsError -> "Please provide a year"
    else
      _ ->
        league = Enum.fetch!(String.split(command, " ", parts: 2), 0)
        season = Enum.fetch!(String.split(command, " ", parts: 2), 1)

        http_response =
          HTTPoison.get!(
            "https://api-football-standings.azharimm.site/leagues/#{league}/standings?season=#{season}"
          )

        {:ok, http_data} = Poison.decode(http_response.body)

        if http_data["status"] do
          league_name = http_data["data"]["name"]
          league_year = http_data["data"]["seasonDisplay"]
          league_standings = http_data["data"]["standings"]

          standings_format_list =
            Enum.map(league_standings, fn team ->
              "#{team["note"]["rank"]}. **#{team["team"]["displayName"]}** (#{team["team"]["abbreviation"]})"
            end)

          "**#{league_name} #{league_year}**\n\n" <> Enum.join(standings_format_list, "\n")
        else
          "Please use !football leagues to check if league Id is correct or use !football seasons [league id] to make sure the year provided is available."
        end
    end
  end
end
