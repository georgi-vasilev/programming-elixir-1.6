defmodule Tracer do
  import IO.ANSI, except: [clear: 0]

  def dump_args(args) do
    args |> Enum.map(&inspect/1) |> Enum.join(", ")
  end

  def dump_defn(name, args) do
    "#{name}(#{dump_args(args)})"
  end

  # When we pass definition with guard we get this AST:
  # definition #=> {:when, [line: 61, column: 22],
  # [
  #  {:add_list, [line: 61, column: 7], [{:list, [line: 61, column: 16], nil}]},
  #  {:is_list, [line: 61, column: 27], [{:list, [line: 61, column: 35], nil}]}
  # ]}
  defmacro def(definition, do: body) do
    case definition do
      {:when, _, [{name, _, args} = head, guard_ast]} ->
        args = args || []

        quote do
          Kernel.def unquote(head) when unquote(guard_ast) do
            IO.puts("==> call: #{Tracer.dump_defn(unquote(name), unquote(args))}")
            result = unquote(body)
            IO.puts("<== result: #{result}")
            result
          end
        end

      {name, _, args} ->
        args = args || []

        quote do
          Kernel.def unquote(definition) do
            IO.puts([
              white(),
              green_background(),
              "==> call: ",
              reset(),
              "#{Tracer.dump_defn(unquote(name), unquote(args))}"
            ])

            result = unquote(body)

            IO.puts([
              white(),
              green_background(),
              "<== result: ",
              reset(),
              "#{result}"
            ])

            result
          end
        end
    end
  end

  # Example from the book:
  defmacro def(definition = {name, _, args}, do: content) do
    # definition is this case is AST like:
    # {:puts_sum_three, [line: 16, column: 7],
    # [
    #   {:a, [line: 16, column: 22], nil},
    #   {:b, [line: 16, column: 25], nil},
    #   {:c, [line: 16, column: 28], nil}
    # ]}
    # IO.inspect(definition) remove comment to show the AST structure
    quote do
      Kernel.def unquote(definition) do
        IO.puts([
          white(),
          green_background(),
          "==> call: ",
          reset(),
          "#{Tracer.dump_defn(unquote(name), unquote(args))}"
        ])

        result = unquote(content)

        IO.puts([
          white(),
          green_background(),
          "<== result: ",
          reset(),
          "#{result}"
        ])

        result
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import unquote(__MODULE__), only: [def: 2]
    end
  end
end

defmodule Test do
  use Tracer

  def puts_sum_three(a, b, c), do: IO.inspect(a + b + c)

  def add_list(list) when is_list(list), do: Enum.reduce(list, 0, &(&1 + &2))
end

Test.puts_sum_three(1, 2, 3)
Test.add_list([1, 2, 3, 4, 5])
