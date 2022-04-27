defmodule Password do
  def argument_handler(argument) do
    {command, param} = argument_splitter(argument)

    case command do
      "help" -> help()
      "generate" -> generate(param)
    end
  end

  defp argument_splitter(argument) do
    if String.contains?(argument, " ") do
      split_result = String.split(argument, " ", parts: 2)
      {Enum.fetch!(split_result, 0), Enum.fetch!(split_result, 1)}
    else
      {argument, round(:rand.uniform(25))}
    end
  end

  defp help do
    "Use **!password generate** to generate a random password, you can determine its length by using **!password generate *number***"
  end

  defp generate(length) do
    http_response =
      HTTPoison.get!(
        "https://passwordinator.herokuapp.com/?num=true&char=true&caps=true&len=#{length}"
      )

    {:ok, http_data} = Poison.decode(http_response.body)

    "**Your new Password**: " <> http_data["data"]
  end
end
