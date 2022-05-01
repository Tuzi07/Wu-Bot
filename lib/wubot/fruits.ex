defmodule Fruits do
  def handle_argument(command) do
    case command do
      "random" ->
        fruit_rand()

      "all" ->
        fruit_list()
      "help" ->
        help()
      _ ->
        fruit_by_name(command)
    end
  end
  
  defp help do
    "**Fruit Command List**\n\n`random`\n`all`\n`[fruit name]`"
  end

  defp fruit_by_name(name) do
    http_response = HTTPoison.get!("https://www.fruityvice.com/api/fruit/#{name}")

    {:ok, fruit_data} = Poison.decode(http_response.body)

    if fruit_data["error"] do
      "That fruit does not seem to exist in this world."
    else
      format_fruit(fruit_data)
    end
  end

  defp fruit_rand do
    http_response = HTTPoison.get!("https://www.fruityvice.com/api/fruit/all")

    {:ok, http_data} = Poison.decode(http_response.body)
    random_number = length(http_data) |> :rand.uniform()

    Enum.at(http_data, random_number)
    |> format_fruit()
  end

  defp fruit_list do
    http_response = HTTPoison.get!("https://www.fruityvice.com/api/fruit/all")

    {:ok, http_data} = Poison.decode(http_response.body)

    fruit_names = Enum.map(http_data, fn fruit -> fruit["name"] end)
    "**Fruit List**\n\n" <> Enum.join(fruit_names, "\n")
  end

  defp format_fruit(fruit_obj) do
    fruit_name = fruit_obj["name"]
    nutrition_data_holder = fruit_obj["nutritions"]
    calories = "Calories: #{nutrition_data_holder["calories"]}\n"
    carbs = "Carbohydrates: #{nutrition_data_holder["carbohydrates"]}\n"
    protein = "Protein: #{nutrition_data_holder["protein"]}\n"
    fat = "Fat: #{nutrition_data_holder["fat"]}\n"
    sugar = "Sugar: #{nutrition_data_holder["sugar"]}\n"

    "**#{fruit_name}**\n\n#{calories}#{carbs}#{protein}#{fat}#{sugar}"
  end
end
