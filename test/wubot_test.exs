defmodule WubotTest do
  use ExUnit.Case
  doctest Wubot

  test "greets the world" do
    assert Wubot.hello() == :world
  end
end
