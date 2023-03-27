defmodule Logical.Map do
  import Kernel, except: [and: 2, or: 2, match?: 2]
  alias Logical.Proposition
  alias Proposition.Connective
  alias Proposition.Binary

  def match?(%Connective{operator: operator} = proposition, other) do
    apply_impl(operator, [proposition, other]) |> negate(proposition)
  end

  def match?(%Binary{operator: operator} = proposition, other) do
    apply_impl(operator, [other[proposition.field], proposition.value]) |> negate(proposition)
  end

  def apply_impl(operator, args) do
    operator = String.to_existing_atom(operator)
    apply(__MODULE__, operator, args)
  end

  def (%Connective{} = proposition) and other do
    Enum.map(proposition.value, &match?(&1, other)) |> Enum.all?()
  end

  def (%Connective{} = proposition) or other do
    Enum.map(proposition.value, &match?(&1, other)) |> Enum.any?()
  end

  def negate(other, %{negate: true}), do: !other
  def negate(other, _), do: other

  def equal(left, right) do
    left == right
  end

  def greater_than(nil, _right), do: false
  def greater_than(_left, nil), do: false

  def greater_than(left, right) do
    left > right
  end
end
