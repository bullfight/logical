defmodule Logical.PropositionTest do
  use ExUnit.Case
  doctest Logical.Proposition

  alias Logical.Proposition
  alias Logical.Proposition.Binary
  alias Logical.Proposition.Connective

  test "build binary" do
    expectation = %Binary{operator: "equal", field: "foo", value: 1}

    assert expectation ==
             Proposition.build(%{
               "operator" => "equal",
               "field" => "foo",
               "value" => 1
             })
  end

  test "build connective" do
    expectation = %Connective{
      operator: "and",
      value: [
        %Binary{operator: "equal", field: "foo", value: 1},
        %Binary{operator: "equal", field: "bar", value: 10}
      ]
    }

    assert expectation ==
             Proposition.build(%{
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
