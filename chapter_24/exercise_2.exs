defprotocol Rot13 do
  @fallback_to_any true
  def rot13(string)
end

defimpl Rot13, for: List do
  def rot13(list) do
    Enum.map(list, fn char ->
      if char in ?a..?z do
        rem(char - ?a + 13, 26) + ?a
      else
        char
      end
    end)
  end
end

defimpl Rot13, for: BitString do
  def rot13(bin) do
    bin
    |> String.to_charlist()
    |> Rot13.List.rot13()
    |> List.to_string()
  end
end

defmodule TestRotatable do
  # Unix path to the dictionary file
  @path "/usr/share/dict/words"

  def read_file do
    @path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&String.downcase/1)
    |> Enum.into([])
  end

  def pairs(words) do
    words
    |> Enum.map(&{&1, Rot13.rot13(&1)})
    |> Enum.reduce(MapSet.new(), fn {word, rotated}, acc ->
      words_map = words |> MapSet.new()

      if MapSet.member?(words_map, rotated) and word <= rotated do
        MapSet.put(acc, {word, rotated})
      else
        acc
      end
    end)
  end
end
