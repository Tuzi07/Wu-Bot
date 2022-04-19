defmodule ProgrammingQuote do
  def random_quote() do
    htpp_response = HTTPoison.get!("https://programming-quotes-api.herokuapp.com/quotes/random")

    {:ok, http_data} = Poison.decode(htpp_response.body)

    author = http_data["author"]
    programming_quote = http_data["en"]
    "\"#{programming_quote}\" - #{author}"
  end
end
