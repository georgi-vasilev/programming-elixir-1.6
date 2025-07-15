defmodule StringAndBinaries do
  # Write a function that returns true if a single-quoted string contains only
  # printable ASCII characters (space through tilde)
  def is_in_range([head | _tail] = _char_list) when head in ?\s..?~, do: true
  def is_in_range(_), do: false

  # Exercise 2: write an anagram?(word1, word2) that returns true if its parameters are anagram
  def anagram?(word1, word2) do
    word1_frequency_map =
      word1
      |> String.downcase()
      |> String.graphemes()
      |> Enum.frequencies()

    word2_frequency_map =
      word2
      |> String.downcase()
      |> String.graphemes()
      |> Enum.frequencies()

    Map.equal?(word1_frequency_map, word2_frequency_map)
  end

  # Exercise 3: try the following in IEx:
  # iex> ['cat' | 'dog']
  # ['cat', 100, 111, 103]
  # Why does IEx print 'cat' as string but 'dog' as individual numbers?
  # Because | is a list constructor so it builds
  # ['cat' | [100, 111, 103]]
  # and the result is [~c"cat", 100, 111, 103]

  # Exercise 4 Write a function that takes a single-quoted string of the form number [+-*/]
  # number and returns the result of the calculation. The indiviaul numbers do not have leading plus or minus signs
  # calculate('123+27') # => 150
  def calculate(charlist) when is_list(charlist) do
    expression = to_string(charlist)

    {left, operator, right} = parse_expression(expression)

    apply_operator(operator, String.to_integer(left), String.to_integer(right))
  end

  defp parse_expression(expr) do
    Enum.find_value(["+", "-", "*", "/"], fn op ->
      case String.split(expr, op) do
        [left, right] -> {left, op, right}
        _ -> nil
      end
    end)
  end

  defp apply_operator("+", a, b), do: a + b
  defp apply_operator("-", a, b), do: a - b
  defp apply_operator("*", a, b), do: a * b
  defp apply_operator("/", a, b), do: a / b

  # Exercise 4
  def center(word_list) do
    longest_word_len =
      word_list
      |> Enum.max_by(fn x -> String.length(x) end)
      |> String.length()

    word_list
    |> Enum.each(fn word ->
      word_len = String.length(word)
      total_padding = longest_word_len - word_len
      left_pad = div(total_padding, 2)
      right_pad = total_padding - left_pad

      centered =
        word
        |> String.pad_leading(left_pad + word_len)
        |> String.pad_trailing(longest_word_len)

      IO.puts(centered)
    end)
  end
end
