defmodule Ticker do
  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send(:global.whereis_name(@name), {:register, client_pid})
  end

  def generator(clients, index \\ 0) do
    receive do
      {:register, pid} ->
        IO.puts("Registering #{inspect(pid)}")
        generator(clients ++ [pid], index)
    after
      @interval ->
        IO.puts("tick")

        case clients do
          [] ->
            generator(clients, index)

          _ ->
            client = Enum.at(clients, index)
            send(client, {:tick, index})
            new_index = rem(index + 1, length(clients))
            generator(clients, new_index)
        end
    end
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick, counter} ->
        IO.puts("tock in client #{counter}")
        receiver()
    end
  end
end
