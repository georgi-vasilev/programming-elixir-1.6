defmodule MyList do
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail)

  def square([]), do: []
  def square([head | tail]), do: [head * head | square(tail)]

  def add_1([]), do: []
  def add_1([head | tail]), do: [head + 1 | add_1(tail)]

  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]

  def reduce([], value, _func), do: value
  def reduce([head | tail], value, func) do
    reduce(tail, func.(head, value), func)
  end

  # Exercise 1 - mapsum func that takes a list and a func applies the func to each element of the list
  # and then sums the result
  # e.g. MyList.mapsum([1,2,3], &(&1 * &1))
  # 14
  def mapsum([], _func), do: 0
  def mapsum([head | tail], func) do
    func.(head) + mapsum(tail, func)
  end

  # Exercise 2 - write a max(list) that return the element with maximum value in the list
  def max([x]), do: x
  def max([head | tail]) do
    max_tail = max(tail)
    if head > max_tail, do: head, else: max_tail
  end

  # Exercise 3 - An elixir single quoted string is actually a list of individual character codes.
  # Write a ceasar(list, n) function that adds n to each list element, wrapping if the addition results in character greater than z.
  # e.g MyList.ceaser('ryvkve', 13)
  def ceaser([], _n), do: []
  def ceaser([head | tail], n) do
    shifted = ?a + rem((head - ?a + n), 26)
    [shifted | ceaser(tail, n)]
  end

  # Exercise 4 - Write a function MyList.span(from, to) that returns a list of the number from up to to
  def span(from, to) when from > to, do: []
  def span(from, to) when from == to, do: [from]
  def span(from, to) do
    [from | span(from + 1, to)]
  end
end
