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

  # Exercise 5
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

      centered =
        word
        |> String.pad_leading(left_pad + word_len)
        |> String.pad_trailing(longest_word_len)

      IO.puts(centered)
    end)
  end

  # Exercise 6
  # "oh. a DOG. woof. "
  # OH. A dog. Woof. "
  def capitalize_sentence(sentence) do
    sentence |> String.split(". ") |> Enum.map(&String.capitalize(&1)) |> Enum.join(". ")
  end

  # Exercise 7 - rewrite the function from chapter_7 and read from file.
  def apply_tax(file_name, tax_rates) do
    with {:ok, file} <- File.open(file_name) do
      IO.stream(file, :line)
      |> Enum.take_while(&(&1 != "\n"))
      |> Enum.drop(1)
      |> Enum.map(&String.replace(&1, "\n", ""))
      |> Enum.map(&parse_order(&1, tax_rates))
    else
      {:error, _} -> :error
    end
  end

  defp parse_order(line, tax_rates) do
    [id, ":" <> ship_to_str, net_str] = String.split(line, ",")

    ship_to = String.to_atom(ship_to_str)
    net = String.to_float(net_str)
    total = net + net * Keyword.get(tax_rates, ship_to, 0.0)

    %{id: id, ship_to: ship_to, net: net, total: total}
  end
end
