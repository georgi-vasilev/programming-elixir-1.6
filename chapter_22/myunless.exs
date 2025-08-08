defmodule MyUnless do
  defmacro unless(condition, clause) do
    do_clause = Keyword.get(clause, :do, nil)
    else_clause = Keyword.get(clause, :else, nil)

    quote do
      if !unquote(condition) do
        unquote(do_clause)
      else
        unquote(else_clause)
      end
    end
  end
end

defmodule Example do
  require MyUnless

  def condition(cond) do
    MyUnless.unless cond do
      IO.puts("This will be printed because the condition is false.")
    else
      IO.puts("This will be printed because the condition is true.")
    end
  end
end
