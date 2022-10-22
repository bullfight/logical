defmodule LogicalTest do
  use ExUnit.Case
  doctest Logical

  test "greets the world" do
    assert Logical.hello() == :world
  end
end
