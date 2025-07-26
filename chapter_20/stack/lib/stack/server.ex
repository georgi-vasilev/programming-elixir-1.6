defmodule Stack.Server do
  use GenServer
  alias Stack.Stash

  @vsn "0"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__, debug: [:trace])
  end

  @impl true
  def init(_) do
    {:ok, Stash.get()}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, [], []}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, element}, stack) do
    Stash.push(element)
    {:noreply, [element | stack]}
  end

  @impl true
  def terminate(reason, stack) do
    IO.puts("Terminating due to #{reason}. Last state: #{stack}.")
    IO.puts("Returning to previous state")
    Stash.update(stack)
  end
end
