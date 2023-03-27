defmodule Logical.DataFrameTest do
  use ExUnit.Case
  doctest Logical.DataFrame

  alias Logical.Proposition.Unary
  alias Logical.Proposition.Binary
  alias Logical.Proposition.Connective
  alias Logical.DataFrame, as: LDF

  alias Explorer.DataFrame, as: DF

  test "filter/2 with equal comparison" do
    df = DF.new(a: [1, 2, 3, 2], b: [5.3, 2.4, 1.0, 2.0])

    # df1 = DF.filter_with(df, fn ldf -> Series.equal(ldf["a"], 2) end)
    proposition = %Binary{operator: "equal", field: "a", value: 2}
    df1 = LDF.filter(proposition, df)
    assert DF.to_columns(df1, atom_keys: true) == %{a: [2, 2], b: [2.4, 2.0]}

    # df2 = DF.filter_with(df, fn ldf -> Series.equal(1.0, ldf["b"]) end)
    proposition = %Binary{operator: "equal", field: "b", value: 1.0}
    df2 = LDF.filter(proposition, df)
    assert DF.to_columns(df2, atom_keys: true) == %{a: [3], b: [1.0]}

    # df3 =
    #  DF.filter_with(df, fn ldf -> Series.equal(ldf["a"], Series.from_list([1, 0, 3, 0])) end)
    proposition = %Binary{operator: "equal", field: "a", value: [1, 0, 3, 0]}
    df3 = LDF.filter(proposition, df)
    assert DF.to_columns(df3, atom_keys: true) == %{a: [1, 3], b: [5.3, 1.0]}

    # df4 =
    #   DF.filter_with(df, fn ldf -> Series.equal(Series.from_list([0, 0, 1.0, 0]), ldf["b"]) end)
    proposition = %Binary{operator: "equal", field: "b", value: [0, 0, 1.0, 0]}
    df4 = LDF.filter(proposition, df)
    assert DF.to_columns(df4, atom_keys: true) == %{a: [3], b: [1.0]}

    # df5 = DF.filter_with(df, fn ldf -> Series.equal(ldf["a"], ldf["b"]) end)
    proposition = %Binary{
      operator: "equal",
      field: "a",
      value: %Unary{operator: "value", field: "b"}
    }

    df5 = LDF.filter(proposition, df)
    assert DF.to_columns(df5, atom_keys: true) == %{a: [2], b: [2.0]}
  end

  test "filter/2 with equal negation" do
    df = DF.new(a: [1, 2, 3, 2], b: [5.3, 2.4, 1.0, 2.0])

    # df1 = DF.filter_with(df, fn ldf -> Series.equal(ldf["a"], 2) end)
    proposition = %Binary{operator: "equal", field: "a", value: 2, negate: true}
    df1 = LDF.filter(proposition, df)
    assert DF.to_columns(df1, atom_keys: true) == %{a: [1, 3], b: [5.3, 1.0]}
  end

  test "filter/2 with greater_than inequality" do
    df = DF.new(a: [1, 2, 3, 2], b: [5.3, 2.4, 1.0, 2.0])

    proposition = %Binary{operator: "greater_than", field: "b", value: 3.0}
    df1 = LDF.filter(proposition, df)
    assert DF.to_columns(df1, atom_keys: true) == %{a: [1], b: [5.3]}
  end

  test "filter/2 with and connective" do
    df = DF.new(a: [1, 2, 3, 2], b: [5.3, 2.4, 1.0, 2.0])

    proposition = %Connective{
      operator: "and",
      value: [
        %Binary{operator: "equal", field: "a", value: 2},
        %Binary{operator: "greater_than", field: "b", value: 2.0}
      ]
    }

    df1 = LDF.filter(proposition, df)
    assert DF.to_columns(df1, atom_keys: true) == %{a: [2], b: [2.4]}
  end
end
