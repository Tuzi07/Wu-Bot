defmodule Bible do
  def random_quote() do
    htpp_response = HTTPoison.get!("https://www.abibliadigital.com.br/api/verses/nvi/random")

    {:ok, http_data} = Poison.decode(htpp_response.body)

    text = http_data["text"]
    chapter = http_data["chapter"]
    number = http_data["number"]
    author = http_data["book"]["author"]

    "\"#{text}\" - #{author} #{chapter}:#{number}"
  end
end
