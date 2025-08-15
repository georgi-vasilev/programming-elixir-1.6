# The function Float.parse converts leading characters of a string to a float,
# returning either a tuple containing the value and the rest of the string, or the atom :error
# Update your CSV sigil so that numbers are automatically converted:
# csv = ~v """
# 1,2,3.14
# cat, dog
# """
# would generate [["1.0", "2.0", "3"], ["cat", "dog"]]

defmodule MySigils do
  def sigil_v(string, []) do
    string
    |> String.replace("\"", "")
    |> String.split("\n")
    |> Enum.reduce(
      [],
      fn rows, acc ->
        parsed_row = parse_cols_in_rows(rows)
        [parsed_row | acc]
      end
    )
    |> Enum.reverse()
  end

  defp parse_cols_in_rows(rows) do
    rows
    |> String.split(",")
    |> Enum.reduce(
      [],
      fn row, row_acc ->
        case Float.parse(row) do
          {value, _} ->
            [value | row_acc]

          :error ->
            [row | row_acc]
        end
      end
    )
    |> Enum.reverse()
  end
end
