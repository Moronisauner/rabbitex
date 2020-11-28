defmodule RabbitexTest do
  use ExUnit.Case
  doctest Rabbitex

  test "greets the world" do
    assert Rabbitex.hello() == :world
  end
end
