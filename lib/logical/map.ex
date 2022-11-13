defmodule Logical.Map do
  import Kernel, except: [and: 2, match?: 2]
  alias Logical.Proposition
  alias Proposition.Connective

  def match?(%{operator: operator} = proposition, other) do
    apply_impl(operator, [proposition, other])
  end

  def apply_impl(operator, args) do
    operator = String.to_existing_atom(operator)
    apply(__MODULE__, operator, args)
  end

  def (%Connective{} = proposition) and other do
    Enum.map(proposition.value, &match?(&1, other))
  end

  def equal(proposition, other) do
    other[proposition.field] == proposition.value
  end

  def greater_than(proposition, other) do
    other[proposition.field] > proposition.value
  end
end
