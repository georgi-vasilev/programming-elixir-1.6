defmodule GenserverStack.Server do
  use GenServer

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack, name: __MODULE__, debug: [:trace])
  end

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, :empty, []}
  end

  @impl true
  def handle_cast({:push, element}, stack) do
    {:noreply, [element | stack]}
  end

  @impl true
  def terminate(reason, state) do
    IO.puts("Terminating due to #{reason}. Last state: #{state}.")
    :ok
  end
end
