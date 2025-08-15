# In many cases, inspect will return a valid Elixir literal for the value being inspected.
# Update the inspect function for structs so that it returns valid Elixir code to construct a new struct
# equal to the value being inspected

# iex> new_user = %User{name: "Ivan", age: 25}
# iex> inspect new_user
# "%User{name: \"John\", age: 25}"

defmodule User do
  defstruct name: "", age: nil
end

defimpl Inspect, for: User do
  import Inspect.Algebra

  def inspect(%User{name: name, age: age}, _opts) do
    concat([
      "%User{",
      "name: #{inspect(name)},",
      "age: #{inspect(age)}",
      "}"
    ])
  end
end
