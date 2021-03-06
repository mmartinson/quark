defprotocol Quark.Sequence do
  @moduledoc ~S"""
  """

  @doc ~S"""
  The beginning of the sequence.

  For instance, integers are generally thought of as centering around 0

  ```elixir

  iex> origin(9)
  0

  ```

  """
  @spec origin(any) :: any
  def origin(specimen)

  @doc ~S"""
  The `succ`essor in sequence.

  For integers, this is the number above.

  ```elixir

  iex> succ(1)
  2

  iex> 10 |> origin |> succ |> succ
  2

  ```

  """
  @spec succ(any) :: any
  def succ(element)

  @doc ~S"""
  The `pred`essor in the sequence.

  For integers, this is the number below.

  ```elixir

  iex> pred(10)
  9

  iex> 42 |> origin |> pred |> pred
  -2

  ```

  """
  @spec pred(any) :: any
  def pred(element)
end

defimpl Quark.Sequence, for: Integer do
  def origin(num), do: 0
  def succ(num), do: num + 1
  def pred(num), do: num - 1
end
