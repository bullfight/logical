defmodule Logical.DataFrame do
  import Kernel, except: [and: 2, or: 2]
  alias Kernel, as: K
  alias Logical.Predicate.Unary
  alias Explorer.DataFrame, as: DF
  alias Explorer.Series

  def filter(%{operator: operator} = predicate, data_frame) do
    DF.filter_with(data_frame, fn ldf -> apply_impl(operator, [predicate, ldf]) end)
  end

  def apply_impl(operator, [predicate | _data_frame] = args) do
    operator = String.to_existing_atom(operator)
    result = K.apply(__MODULE__, operator, args)
    negate(predicate, result)
  end

  def predicate and data_frame do
    Enum.map(predicate.value, &apply_impl(&1.operator, [&1, data_frame]))
    |> Enum.reduce(fn x, acc -> Series.and(acc, x) end)
  end

  def predicate or data_frame do
    Enum.map(predicate.value, &apply_impl(&1.operator, [&1, data_frame]))
    |> Enum.reduce(fn x, acc -> Series.or(acc, x) end)
  end

  def negate(%{negate: true}, data_frame), do: Series.not(data_frame)
  def negate(_, data_frame), do: data_frame

  def equal(predicate, data_frame) do
    Series.equal(data_frame[predicate.field], cast_value(predicate.value, data_frame))
  end

  def greater_than(predicate, data_frame) do
    Series.greater(data_frame[predicate.field], cast_value(predicate.value, data_frame))
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
