defmodule TestTest do
  use ExUnit.Case
  doctest Elixir_test

  test "greets the world" do
    assert Elixir_test.hello() == :world
  end
end
