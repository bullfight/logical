defmodule Logical do
  def from_json(json) do
    Jason.decode!(json)
    |> Logical.Predicate.build()
  end
end
