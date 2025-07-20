defmodule Exercise do
  def create_process() do
    spawn(Exercise, :greet, [])
  end

  def greet do
    receive do
      {sender, msg} ->
        send(sender, {:ok, "Hello #{msg}"})
        greet()
    end
  end
end

fred_pid = Exercise.create_process()
betty_pid = Exercise.create_process()

send(fred_pid, {self(), "Fred"})
send(betty_pid, {self(), "Betty"})

for _ <- 1..2 do
  receive do
    {:ok, message} -> IO.puts(message)
  after
    500 -> IO.puts("Timeout")
  end
end
