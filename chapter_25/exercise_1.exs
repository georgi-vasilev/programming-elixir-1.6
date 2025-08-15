# write a sigil ~v that parses multiple lines of comma-separated values data,
# returning a list where each element is a row of data and each field is separated by a comma.
# for example
# csv = ~v """
# 1,2,3
# cat, dog
# """
# would generate [["1", "2", "3"], ["cat", "dog"]]

defmodule MySigils do
  def sigil_v(string, []) do
    string
    |> String.split("\n")
    |> Enum.reduce(
      [],
      fn rows, acc ->
        [
          rows
          |> String.split(",")
          |> Enum.reduce(
            [],
            fn row, row_acc ->
              [row |> String.replace("\"", "") |> String.trim() | row_acc]
            end
          )
          |> Enum.reverse()
          | acc
        ]
      end
    )
    |> Enum.reverse()
  end
end
