defmodule IsEven do
  def handle_argument(argument) do
    case argument do
      "help" ->
        help()

      _ ->
        message(argument)
    end
  end

  defp help() do
    "**IsEven Command**\n\n`[number]`"
  end

  defp message(argument) do
    htpp_response = HTTPoison.get!("https://api.isevenapi.xyz/api/iseven/#{argument}/")

    {:ok, http_data} = Poison.decode(htpp_response.body)

    if http_data["error"] do
      "Invalid number."
    else
      iseven = http_data["iseven"]

      if iseven do
        "Is even!"
      else
        "Is odd!"
      end
    end
  end
end
