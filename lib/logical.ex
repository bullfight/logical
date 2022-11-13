defmodule Logical do
  def from_json(json) do
    Jason.decode!(json)
    |> Logical.Proposition.build()
  end
end
