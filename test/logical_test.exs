defmodule LogicalTest do
  use ExUnit.Case
  doctest Logical

  alias Logical.Proposition.Binary
  alias Logical.Proposition.Connective

  test "binary from_json" do
    expectation = %Binary{operator: "equal", field: "foo", value: 1}
    assert expectation == Logical.from_json(~s({
        "operator": "equal",
        "field": "foo",
        "value": 1
      }))
  end

  test "operator from_json" do
    expectation = %Connective{
      operator: "and",
      value: [
        %Binary{operator: "equal", field: "foo", value: 1},
        %Binary{operator: "equal", field: "bar", value: 10}
      ]
    }

    assert expectation == Logical.from_json(~s({
        "operator": "and",
        "value": [
          {
            "operator": "equal",
            "field": "foo",
            "value": 1
          },
          {
            "operator": "equal",
            "field": "bar",
            "value": 10
          }
        ]
      }))
  end
end
