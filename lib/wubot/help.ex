defmodule Help do
  def help_message() do
    "**List of commands**\n" <> command_descriptions()
  end

  defp command_descriptions() do
    Enum.join(command_descriptions_list())
  end

  defp command_descriptions_list() do
    Enum.map(command_description_map(), fn {key, value} ->
      "#{key} - #{value}\n"
    end)
  end

  defp command_description_map() do
    %{
      "!help" => "Shows this message",
      "!bible" => "Shows a verse from the Holy Bible in Portuguese",
      "!covid" => "Covid info",
      "!crypto" => "Shows cryptocurrency information",
      "!football" => "Football leagues info",
      "!fox" => "Shows a fox image",
      "!fruit" => "Fruit data",
      "!iseven" => "Shows if number is even",
      "!password" => "Password generator",
      "!programmingcontest" => "Programming Contest info",
      "!programmingquote" => "Shows a quote about programming"
    }
  end
end
