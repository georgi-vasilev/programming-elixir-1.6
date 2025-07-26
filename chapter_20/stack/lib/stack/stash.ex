defmodule Stack.Stash do
  use GenServer
  @me __MODULE__

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack, name: @me)
  end

  def get do
    GenServer.call(@me, {:get})
  end

  def push(element) do
    GenServer.cast(@me, {:push, element})
  end

  def update(stack) do
    GenServer.cast(@me, {:update, stack})
  end

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call({:get}, _from, stack) do
    {:reply, stack, stack}
  end

  @impl true
  def handle_cast({:push, element}, stack) do
    {:noreply, [element | stack]}
  end

  @impl true
  def handle_cast({:update, stack}, _state) do
    {:noreply, stack}
  end
end
