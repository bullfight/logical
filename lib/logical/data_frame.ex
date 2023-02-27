defmodule Logical.DataFrame do
  import Kernel, except: [and: 2, match?: 2]
  alias Kernel, as: K
  alias Logical.Proposition.Unary
  alias Explorer.DataFrame, as: DF
  alias Explorer.Series

  def filter(%{operator: operator} = proposition, data_frame) do
    DF.filter_with(data_frame, fn ldf -> apply_impl(operator, [proposition, ldf]) end)
  end

  def apply_impl(operator, args) do
    operator = String.to_existing_atom(operator)
    K.apply(__MODULE__, operator, args)
  end

  def conjunction(proposition, data_frame) do
    Enum.map(proposition.value, &apply_impl(&1.operator, [&1, data_frame]))
    |> Enum.reduce(fn x, acc -> Series.and(acc, x) end)
  end

  def equal(proposition, data_frame) do
    Series.equal(data_frame[proposition.field], cast_value(proposition.value, data_frame))
  end

  def greater_than(proposition, data_frame) do
    Series.greater(data_frame[proposition.field], cast_value(proposition.value, data_frame))
  end

  def cast_value(value, data_frame) when K.is_struct(value, Unary) do
    data_frame[value.field]
  end

  def cast_value(value, _data_frame) when K.is_list(value) do
    Series.from_list(value)
  end

  def cast_value(value, _data_frame) do
    value
  end
end
