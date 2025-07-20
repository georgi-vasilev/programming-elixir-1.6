defmodule FibSolver do
  def fib(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:fib, n, client} ->
        send(client, {:answer, n, fib_calc(n), self()})

      {:shutdown} ->
        exit(:normal)
    end
  end

  defp fib_calc(0), do: 0
  defp fib_calc(1), do: 1
  defp fib_calc(n), do: fib_calc(n - 1) + fib_calc(n - 2)
end

defmodule CatFinder do
  def find(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:find, file_name, client} ->
        send(client, {:answer, file_name, find_cat(file_name), self()})

      {:shutdown} ->
        exit(:normal)
    end
  end

  defp find_cat(file_name) do
    file_content = File.read!(file_name)

    file_content
    |> String.downcase()
    |> String.replace(~r/[^\p{L}\s]/u, "")
    |> String.split(~r/\s+/, trim: true)
    |> Enum.frequencies()
    |> Map.get("end", 0)
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, to_calculate) do
    1..num_processes
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [], module)
  end

  defp schedule_processes(processes, queue, results, module) do
    receive do
      {:ready, pid} when queue != [] ->
        [next | tail] = queue

        task_tag =
          case Process.info(pid, :dictionary) do
            {:dictionary, dict} ->
              cond do
                :fib_solver in dict -> :fib
                :cat_finder in dict -> :find
                true -> :task
              end

            _ ->
              :task
          end

        # OR just match based on the module passed in `run/4` if it's in scope:
        # task_tag = if module == FibSolver, do: :fib, else: :find

        send(pid, {task_tag, next, self()})
        schedule_processes(processes, tail, results, module)

      {:ready, pid} ->
        send(pid, {:shutdown})

        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results, module)
        else
          Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, number, result, _pid} ->
        schedule_processes(processes, queue, [{number, result} | results], module)
    end
  end
end

# to_process = List.duplicate(20, 5)
#
# Enum.each(1..5, fn num_processes ->
#  {time, result} =
#    :timer.tc(
#      Scheduler,
#      :run,
#      [num_processes, FibSolver, :fib, to_process]
#    )
#
#  if num_processes == 1 do
#    IO.puts(inspect(result))
#    IO.puts("\n # time (s)")
#  end
#
#  :io.format("~2B   ~.2f-n", [num_processes, time / 1_000_000.0])
# end)

files = File.ls!()
files_length = length(File.ls!())

{time, result} = :timer.tc(Scheduler, :run, [files_length, CatFinder, :find, files])

if files_length == 1 do
  IO.puts(inspect(result))
  IO.puts("\n # time (s)")
end

:io.format("~2B   ~.2f-n", [files_length, time / 1_000_000.0])
