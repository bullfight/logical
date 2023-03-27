defmodule Logical.Predicate do
  defmodule Unary do
    @enforce_keys [:field, :operator]
    defstruct field: nil, operator: nil, negate: false
  end

  defmodule Binary do
    @enforce_keys [:field, :operator, :value]
    defstruct field: nil, operator: nil, value: nil, negate: false
  end

  defmodule Connective do
    @enforce_keys [:operator, :value]
    defstruct operator: nil, value: nil, negate: false
  end

  @operators ["value"]
  def build(map = %{"operator" => operator, "field" => field})
      when operator in @operators do
    negate = Map.get(map, "negate", false)
    %Unary{operator: operator, field: field, negate: negate}
  end

  @operators ["equal", "greater_than", "less_than"]
  def build(map = %{"operator" => operator, "field" => field, "value" => value})
      when operator in @operators do
    negate = Map.get(map, "negate", false)
    %Binary{operator: operator, field: field, value: value, negate: negate}
  end

  @operators ["and", "or"]
  def build(map = %{"operator" => operator, "value" => value}) when operator in @operators do
    result = Enum.map(value, &build(&1))
    negate = Map.get(map, "negate", false)
    %Connective{operator: operator, value: result, negate: negate}
  end
end
