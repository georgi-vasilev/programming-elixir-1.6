# Collections that implement the Enumerable protocol define count, member?, reduce and slice functions.
# The Enum module uses these to implement methods such as each, filter and map.
# Implement your own versions of each, filter and map in terms of reduce.

defmodule MyEnum do
  def each(enumerable, func) do
    enumerable
    |> Enum.reduce(
      :ok,
      fn element, :ok ->
        func.(element)
        :ok
      end
    )
  end

  def filter(enumerable, func) do
    enumerable
    |> Enum.reduce(
      [],
      fn element, accumulator ->
        if func.(element) do
          [element | accumulator]
        else
          accumulator
        end
      end
    )
    |> Enum.reverse()
  end

  def map(enumerable, func) do
    enumerable
    |> Enum.reduce(
      [],
      fn element, accumulator ->
        [func.(element) | accumulator]
      end
    )
    |> Enum.reverse()
  end
end
