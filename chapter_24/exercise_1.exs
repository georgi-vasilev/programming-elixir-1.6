defprotocol CaesarCypher do
  @fallback_to_any true
  def encrypt(string, shift)

  def rot13(string)
end

defimpl CaesarCypher, for: List do
  def encrypt(list, shift) do
    Enum.map(list, fn char ->
      if char in ?a..?z, do: rem(char - ?a + shift, 26) + ?a, else: char
    end)
  end

  def rot13(list), do: encrypt(list, 13)
end

defimpl CaesarCypher, for: BitString do
  def encrypt(bin, shift) do
    bin
    |> String.to_charlist()
    |> CaesarCypher.List.encrypt(shift)
    |> List.to_string()
  end

  def rot13(bin), do: encrypt(bin, 13)
end
