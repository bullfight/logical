defmodule Logical.MapTest do
  use ExUnit.Case
  doctest Logical.Map

  alias Logical.Proposition.Binary
  alias Logical.Proposition.Connective
  alias Logical.Map

  test "match?/2 binary" do
    binary = %Binary{operator: "equal", field: "foo", value: 1}

    matching = %{"foo" => 1}
    assert Map.match?(binary, matching)

    non_matching = %{"foo" => 2}
    refute Map.match?(binary, non_matching)
  end

  test "match?/2 binary negate" do
    binary = %Binary{operator: "equal", field: "foo", value: 1, negate: true}

    matching = %{"foo" => 1}
    refute Map.match?(binary, matching)

    non_matching = %{"foo" => 2}
    assert Map.match?(binary, non_matching)
  end

  test "match?/2 connective and" do
    operator = %Connective{
      operator: "and",
      value: [
        %Binary{operator: "equal", field: "foo", value: 1},
        %Binary{operator: "greater_than", field: "bar", value: 10}
      ]
    }

    matching = %{"foo" => 1, "bar" => 12}
    assert Map.match?(operator, matching)

    non_matching = %{"foo" => 1, "bar" => 9}
    refute Map.match?(operator, non_matching)

    non_matching = %{"foo" => 1}
    refute Map.match?(operator, non_matching)
  end
end
