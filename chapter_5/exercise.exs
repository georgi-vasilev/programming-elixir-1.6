# Exercise 3
fizzbuzz = fn a, b, c ->
  case {a, b} do
    {0, 0} -> "FizzBuzz"
    {0, _} -> "Fizz"
    {_, 0} -> "Buzz"
    _ -> c
  end
end

# Exercise 4
illogical_fizzbuzz = fn a ->
  fizzbuzz.(rem(n, 3), rem(n, 5), n)
end

Enum.each(10..16, fn n -> IO.inspect(illogical_fizzbuzz.(n)) end)

# Exercise 5
fn prefix ->
  fn second_string -> "#{prefix} #{second_string}" end
end

# Exercise 6
Enum.each([1,2,3,4], &(IO.inspect(&1)))

Enum.map [1,2,3,4], &(&1 + 2)
