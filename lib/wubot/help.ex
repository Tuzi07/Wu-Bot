defmodule Help do
  def help_message() do
    "List of commands:\n" <> command_descriptions()
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
      "!programmingquote" => "Shows random quote about programming",
      "!bible" => "Shows random verse from the Holy Bible in Portuguese"
    }
  end
end
