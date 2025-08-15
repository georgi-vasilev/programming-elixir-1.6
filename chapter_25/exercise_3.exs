# Sometimes the first line of CSV file is a list of column names. Update your code to support the values in each row as a keyword list
# using the column names as the keys
# csv = ~v """
# Item, Qty, Price
# Teddy bear, 4, 34.95
# Milk, 1, 2.99
# Battery, 6, 8.00
# """
# [
# [ Item: "Teddy bear", Qty: 4, Price: 34.95]
# ...
# ]
defmodule MySigils do
  def sigil_v(string, []) do
    csv =
      string
      |> String.replace("\"", "")
      |> String.split("\n", trim: true)

    case does_first_row_contain_headers?(csv) do
      {:headers, headers, rows} ->
        headers_as_atoms = headers |> Enum.map(fn x -> String.to_atom(x) end)
        format_result(headers_as_atoms, rows)

      :no_headers ->
        format_result(csv)
    end
  end

  defp does_first_row_contain_headers?([head | rows]) do
    # Assume first row contains CSV headers
    # If no values is parsed- then we can assume its text only and we can add the headers to a collection
    cols = String.split(head, ",", trim: true)

    non_numeric? =
      cols
      |> Enum.all?(fn h ->
        case Float.parse(String.trim(h)) do
          {_, _} -> false
          :error -> true
        end
      end)

    if non_numeric? do
      {:headers, Enum.map(cols, &String.trim/1), rows}
    else
      :no_headers
    end
  end

  defp format_result(headers, rows) do
    rows
    |> Enum.reduce(
      [],
      fn row_data, acc ->
        splitted_values =
          row_data
          |> String.split(",", trim: true)

        result = Enum.zip(headers, splitted_values)

        [result | acc]
      end
    )
    |> Enum.reverse()
  end

  defp format_result(rows) do
    rows
    |> Enum.map(fn x -> String.split(x, ",") end)
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
