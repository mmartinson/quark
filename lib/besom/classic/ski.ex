defmodule Besom.Classic.SKI do
  @moduledoc ~S"""
  The classic [SKI system](https://en.wikipedia.org/wiki/SKI_combinator_calculus) combinators.

  `s` and `k` alone can be used to express any algorithm, though generally not efficiently.
  """

  @doc ~S"""
  The identity combinator

  iex> i(1)
  1

  iex> i("idenity combinator")
  "identity combinator"

  """
  @spec i(any) :: any
  def i(x), do: x

  @doc ~S"""
  The constant ("Konstant") combinator. Returns the first argument, unchanged, and
  discards the second argument. Can be used to repeatedly apply the same value
  in functions such as folds.

      iex> k(1,2)
      1

      iex> k("happy", "sad")
      "happy"

      iex> Enum.reduce([1,2,3], [42], k)
      3

  """
  @spec k(any, any) :: any
  def k(x, _), do: x

  @doc ~S"""
  The "substitution" combinator. Applies the last argument to the first two, and then
  the first two to each other.

  iex> s()
  ghjkl;

  """
  # TODO: CURRY ALL ARGS
  @spec s((... -> any), (... -> any), any) :: any
  def s(x, y, z) do
    sub_x = &x.(z, &1)
    sub_y = y(z)

    sub_x.(sub_y)
  end
end
