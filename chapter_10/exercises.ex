# Exercise 1.
# Implement the following enum functions using no library functions or list comprehensions:
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

  def split([], _count), do: {[], []}
  def split(list, 0), do: {[], list}

  def split([head | tail], count) do
    {left, right} = split(tail, count - 1)
    {[head | left], right}
  end

  defp do_split(rest, 0, acc), do: {Enum.reverse(acc), rest}
  defp do_split([], _count, acc), do: {Enum.reverse(acc), []}

  defp do_split([head | tail], count, acc) do
    do_split(tail, count - 1, [head | acc])
  end

  def take(_, 0), do: []
  def take([], _count), do: []
  def take([head | tail], count), do: [head | take(tail, count - 1)]

  def flatten([]), do: []
  def flatten([head | tail]) when is_list(head), do: flatten(head) ++ flatten(tail)

  def flatten([head | tail]) do
    [head | flatten(tail)]
  end

  def span(from, to) when from > to, do: []

  def span(from, to) do
    for x <- from..to, is_prime(x), do: x
  end

  defp is_prime(n) when n < 2, do: false
  defp is_prime(2), do: true

  defp is_prime(n) do
    max = :math.sqrt(n) |> trunc()
    Enum.all?(2..max, fn i -> rem(n, i) != 0 end)
  end

  # The Pragmatic bookshelf has offices in Texas (TX) and North Carolina (NC), so we have to charge sales tax
  # on orders shipped to these states. The rates can be expressed as a keyword list (I wish it were that simple...)
  # tax_rates = [ NC: 0.075, TX: 0,08 ]
  # List of orders:
  # orders = [
  #   [id: 123, ship_to: :NC, net_amount: 100.00],
  #   [id: 124, ship_to: :OK, net_amount: 35.50],
  #   [id: 125, ship_to: :TX, net_amount: 24.00],
  #   [id: 126, ship_to: :TX, net_amount: 44.80],
  #   [id: 127, ship_to: :NC, net_amount: 25.00],
  #   [id: 128, ship_to: :MA, net_amount: 10.00],
  #   [id: 129, ship_to: :CA, net_amount: 102.00],
  #   [id: 130, ship_to: :NC, net_amount: 50.00]
  # ]

  # Write a func that takes both lists and returns a copy of the orders but with an extra field
  # total_amount which is the net plus sales tax. If it shipment is not to NC or TX there's no tax applied.

  def apply_tax(tax_rates, orders) do
    orders
    |> Enum.map(fn order ->
      ship_to = Keyword.get(order, :ship_to)
      net_amount = Keyword.get(order, :net_amount)
      tax = Keyword.get(tax_rates, ship_to, 0)
      total = net_amount + net_amount * tax

      Keyword.put(order, :total_amount, total)
    end)
  end
end
