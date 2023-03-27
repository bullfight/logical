# Logical

```elixir
df = Explorer.DataFrame.new(a: [1, 2, 3, 2], b: [5.3, 2.4, 1.0, 2.0])
predicate = Logical.from_json(~s({
  "operator": "and",
  "value": [
    {
      "operator": "equal",
      "field": "a",
      "value": 2
    },
    {
      "operator": "greater_than",
      "field": "b",
      "value": 2.0
    }
  ]
}))

Logical.DataFrame.filter(predicate, df)

#Explorer.DataFrame<
  Polars[1 x 2]
  a integer [2]
  b float [2.4]
>
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `logical` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:logical, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/logical>.

