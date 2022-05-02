defmodule ProgrammingContest do
  def handle_argument(argument) do
    {command, parameter} = split_argument(argument)

    case command do
       "sites" -> sites()
       "contests"-> contests(parameter)
       "help" -> help()
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
    "**Programming Contests Command List**\n\n`sites`\n`contests [site name]`\n*the word **today** may be added after the site name to see contests happening within the next 24 hours only.*"
  end

  defp sites do
    http_response = HTTPoison.get!("https://kontests.net/api/v1/sites")
    {:ok, sites_list} = Poison.decode(http_response.body)

    sites_format = Enum.map(sites_list, fn site -> "**#{Enum.at(site, 0)}**\n*Search Name:* #{Enum.at(site, 1)}\n*Link:* `#{Enum.at(site, 2)}`\n" end)

    "**Programming Contest Sites**\n\n" <> Enum.join(sites_format, "\n")
  end

  defp contests(arguments) do
   {site, today} = split_argument(arguments)

    http_response = HTTPoison.get!("https://kontests.net/api/v1/#{site}")

    try do
      {:ok, _x} = Poison.decode(http_response.body)

    rescue
      MatchError -> "site name invalid use `!programmingcontest sites` to verify"
    else
      _ ->
        {:ok, site_contest_list} = Poison.decode(http_response.body)
        if length(site_contest_list) > 0 do
          if today == "today" or today == "No ARG" do
            case today do
              "No ARG" ->
                contest_format = Enum.map(site_contest_list, fn contest -> "**#{contest["name"]}**\n*Start Time:* #{contest["start_time"]}\n*End Time:* #{contest["end_time"]}\n*Link:* `#{contest["url"]}`\n" end)
                "**Programming Contests from #{site}**\n\n" <> Enum.join(contest_format, "\n")
              "today" ->
                contest_format = Enum.map(site_contest_list, fn contest -> if contest["in_24_hours"]=="Yes" do "**#{contest["name"]}**\n*Start Time:* #{contest["start_time"]}\n*End Time:* #{contest["end_time"]}\n*Link:* `#{contest["url"]}`\n" end end)
                "**Programming Contests from #{site} happening today**\n\n" <> Enum.join(contest_format, "\n")
            end
          else
            "Final argument is invalid."
          end
        else
          "No contests found."
        end
      end
    end
  end
