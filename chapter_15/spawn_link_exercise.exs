defmodule SpawnLinkExercise do
  def greet do
    receive do
      {sender, msg} ->
        send(sender, {:ok, "Hello #{msg}"})
        #exit(:boop)
        raise "Boop i died"
    end
  end

  def create_process do
    spawn_link(SpawnLinkExercise, :greet, [])
  end
end

#{pid, ref} = SpawnLinkExercise.create_process()
pid = SpawnLinkExercise.create_process()

send(pid, {self(), "World!"})
import :timer, only: [sleep: 1]
sleep(500)

receive do
  {:ok, msg} ->
    IO.puts("Got response: #{msg}")

    #{:DOWN, ^ref, :process, ^pid, reason} ->
    #IO.puts("Child process #{inspect(pid)} died: #{inspect(reason)}")
after
  1000 ->
    IO.puts("Timeout brotha")
end
