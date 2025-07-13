# Exercise 1.
# Implemen the following enum functions using no library functions or list comprehensions:
# all?, each, filter, split, take

defmodule CustomEnums do
  def all?([], _func), do: true

  def all?([head | tail], func) do
    if func.(head) do
      all?(tail, func)
    else
      false
    end
  end

  def each([], _func), do: []

  def each([head | tail], func) do
    [func.(head) | each(tail, func)]
  end

  def filter([], _func), do: []

  def filter([head | tail], func) do
    if func.(head) do
      [head | filter(tail, func)]
    else
      []
    end
  end

  def split([head | tail], count) do
    if count != 0 do
      {[head | split(tail, count)], [tail]}
    end
  end

  def take(_, 0), do: []
  def take([], _count), do: []
  def take([head | tail], count), do: [head | take(tail, count - 1)]

  def flatten([]), do: []
  def flatten([head | tail]) when is_list(head), do: flatten(head) ++ flatten(tail)
  def flatten([head | tail]) do
   [head | flatten(tail)]
  end
end
