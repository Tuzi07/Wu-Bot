defmodule Fox do
  def image() do
    htpp_response = HTTPoison.get!("https://randomfox.ca/floof/")

    {:ok, http_data} = Poison.decode(htpp_response.body)

    image_url = http_data["image"]

    image_url
  end
end
