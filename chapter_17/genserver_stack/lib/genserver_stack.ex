defmodule GenserverStack do
  alias GenserverStack.Server
  @server GenserverStack.Server

  def start_link(stack) do
    Server.start_link(stack)
  end

  def pop do
    GenServer.call(@server, :pop)
  end

  def push(element) do
    GenServer.cast(@server, {:push, element})
  end
end
