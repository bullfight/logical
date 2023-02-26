defmodule Logical.Proposition do
  defmodule Unary do
    @enforce_keys [:field, :operator]
    defstruct field: nil, operator: nil
  end

  defmodule Binary do
    @enforce_keys [:field, :operator, :value]
    defstruct field: nil, operator: nil, value: nil
  end

  defmodule Connective do
    @enforce_keys [:operator, :value]
    defstruct operator: nil, value: nil
  end

  @operators ["value"]
  def build(%{"operator" => operator, "field" => field})
      when operator in @operators do
    %Unary{operator: operator, field: field}
  end

  @operators ["equal", "greater_than", "less_than"]
  def build(%{"operator" => operator, "field" => field, "value" => value})
      when operator in @operators do
    %Binary{operator: operator, field: field, value: value}
  end

  @operators ["and", "or"]
  def build(%{"operator" => operator, "value" => value}) when operator in @operators do
    result = Enum.map(value, &build(&1))
    %Connective{operator: operator, value: result}
  end
end
