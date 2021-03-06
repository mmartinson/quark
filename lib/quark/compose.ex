defmodule Quark.Compose do
  @moduledoc ~S"""
  Function composition is taking two functions, and joining them together to create
  a new function. For example:

  ```elixir

  iex> sum_plus_one = compose([&(&1 + 1), &Enum.sum/1])
  iex> sum_plus_one.([1,2,3])
  7

  ```

  In this case, we have joined `Enum.sum` with a function that adds one, to create
  a new function that takes a list, sums it, and adds one.

  Note that composition normally applies _from right to left_, though `Quark`
  provides the opposite in the form of `*_forward` functions.
  """

  use Quark.Partial
  import Quark, only: [id: 1]

  @doc ~S"""
  Function composition

  ```elixir

  iex> sum_plus_one = compose(&(&1 + 1), &Enum.sum/1)
  iex> [1,2,3] |> sum_plus_one.()
  7

  ```

  """
  @spec compose((... -> any), (... -> any)) :: any
  defdelegate compose(g, f), to: Quark.BCKW, as: :b

  @doc ~S"""
  Function composition, from the tail of the list to the head

  ```elixir

  iex> sum_plus_one = compose([&(&1 + 1), &Enum.sum/1])
  iex> [1,2,3] |> sum_plus_one.()
  7

  ```

  """
  @spec compose([(... -> any)]) :: (... -> any)
  def compose(func_list), do: List.foldr(func_list, &id/1, &compose(&1,&2))
  def compose(), do: &compose(&1)

  @doc ~S"""
  Infix compositon operator

  ```elixir

  iex> sum_plus_one = fn x -> x + 1 end <|> &Enum.sum/1
  iex> sum_plus_one.([1,2,3])
  7

  iex> add_one = &(&1 + 1)
  iex> piped = [1,2,3] |> Enum.sum |> add_one.()
  iex> composed = [1,2,3] |> ((add_one <|> &Enum.sum/1)).()
  iex> piped == composed
  true

  ```

  """
  @spec (... -> any) <|> (... -> any) :: (... -> any)
  def g <|> f, do: compose(g, f)

  @doc ~S"""
  Function composition, from the back of the lift to the front

  ```elixir

  iex> sum_plus_one = compose_forward(&(Enum.sum(&1)), &(&1 + 1))
  iex> [1,2,3] |> sum_plus_one.()
  7

  ```

  """
  @spec compose_forward((... -> any), (... -> any)) :: (... -> any)
  defpartial compose_forward(f,g), do: &(g.(f.(&1)))


  @doc ~S"""
  Compose functions, from the head of the list of functions. The is the reverse
  order versus what one would normally expect (left to right rather than right to left).

  ```elixir

  iex> sum_plus_one = compose_list_forward([&Enum.sum/1, &(&1 + 1)])
  iex> [1,2,3] |> sum_plus_one.()
  7

  ```

  """
  @spec compose_list_forward([(... -> any)]) :: (... -> any)
  defpartial compose_list_forward(func_list), do: Enum.reduce(func_list, &id/1, &compose/2)
end
