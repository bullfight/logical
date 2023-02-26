defmodule Logical.DataFrame do
  import Kernel, except: [and: 2, match?: 2]
  alias Logical.Proposition.Unary
  #alias Logical.Proposition
  #alias Proposition.Connective
  alias Explorer.DataFrame, as: DF
  alias Explorer.Series

  def filter(%{operator: operator} = proposition, other) do
    DF.filter_with(other, apply_impl(operator, [proposition]))
  end

  def apply_impl(operator, args) do
    operator = String.to_existing_atom(operator)
    apply(__MODULE__, operator, args)
  end

  def equal(proposition) do
    fn ldf -> Series.equal(ldf[proposition.field], cast_value(proposition.value, ldf)) end
  end

  def cast_value(value, data_frame) when is_struct(value, Unary) do
    data_frame[value.field]
  end

  def cast_value(value, _data_frame) when is_list(value) do
    Series.from_list(value)
  end

  def cast_value(value, _data_frame) do
    value
  end
end
