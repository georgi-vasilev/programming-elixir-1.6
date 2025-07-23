# the ticker process in this chapter is a central server that sends events to registered clients
# Reimplement this as ring of clients. A client sends a tick to the next client in the ring.
# After 2 seconds that clients sends a tick to its next client.
# When thinking about how to add clients to the ring, remember to deal with the case where a client's receive loop times out
# just as you are adding a new process. What does this say about who has to be responsible for updating the links?

# client = :global.whereis_name pid
# :global.register_name(:two, :erlang.group_leader)

# TODO: Investigate whats wrong and fix it
defmodule RingClient do
  def start(name) do
    pid = spawn(__MODULE__, :loop, [name, nil])
    :global.register_name(name, pid)
    send(:global.whereis_name(:ring_manager), {:register, pid})
  end

  def loop(name, next_pid) do
    receive do
      {:tick, from} ->
        IO.puts("[#{name}] got tick from #{inspect(from)}")
        Process.sleep(2000)
        send(next_pid, {:tick, name})
        loop(name, next_pid)

      {:update_next, new_next} ->
        loop(name, new_next)
    end
  end
end

defmodule RingManager do
  def start do
    pid = spawn(__MODULE__, :loop, [[]])
    :global.register_name(:ring_manager, pid)
  end

  def loop(clients) do
    receive do
      {:register, pid} ->
        IO.puts("New client registered: #{inspect(pid)}")

        case clients do
          [] -> :ok
          [last | _] -> send(last, {:update_next, pid})
        end

        if clients != [], do: send(pid, {:update_next, List.first(clients)})

        if clients == [], do: send(pid, {:update_next, pid})

        loop([pid | clients])
    end
  end
end
