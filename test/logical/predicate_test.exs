defmodule Logical.PredicateTest do
  use ExUnit.Case
  doctest Logical.Predicate

  alias Logical.Predicate
  alias Logical.Predicate.Unary
  alias Logical.Predicate.Binary
  alias Logical.Predicate.Connective

  test "build unary" do
    expectation = %Unary{operator: "value", field: "foo", negate: false}

    assert expectation ==
             Predicate.build(%{
               "operator" => "value",
               "field" => "foo",
               "negate" => false
             })
  end

  test "build binary" do
    expectation = %Binary{operator: "equal", field: "foo", value: 1, negate: false}

    assert expectation ==
             Predicate.build(%{
               "operator" => "equal",
               "field" => "foo",
               "value" => 1,
               "negate" => false
             })
  end

  test "build negated binary" do
    expectation = %Binary{operator: "equal", field: "foo", value: 1, negate: true}

    assert expectation ==
             Predicate.build(%{
               "operator" => "equal",
               "field" => "foo",
               "value" => 1,
               "negate" => true
             })
  end

  test "build connective" do
    expectation = %Connective{
      operator: "and",
      value: [
        %Binary{operator: "equal", field: "foo", value: 1},
        %Binary{operator: "equal", field: "bar", value: 10}
      ],
      negate: false
    }

    assert expectation ==
             Predicate.build(%{
               "operator" => "and",
               "value" => [
                 %{
                   "operator" => "equal",
                   "field" => "foo",
                   "value" => 1
                 },
                 %{
                   "operator" => "equal",
                   "field" => "bar",
                   "value" => 10
                 }
               ]
             })
  end
end
