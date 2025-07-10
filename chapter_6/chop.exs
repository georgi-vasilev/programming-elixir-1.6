defmodule Chop do
  def guess(thought_of, range), do: do_guess(thought_of, range)

  defp do_guess(thought_of, first..last) do
    mid = div(first + last, 2)
    IO.puts("It is #{mid}")

    cond do
      thought_of == mid -> mid
      thought_of < mid -> do_guess(thought_of, first..(mid - 1))
      thought_of > mid -> do_guess(thought_of, (mid + 1)..last)
    end
  end
end
