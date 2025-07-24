defmodule SupervisedStack do
  @server SupervisedStack.Server

  def pop do
    GenServer.call(@server, :pop)
  end

  def push(element) do
    GenServer.cast(@server, {:push, element})
  end
end
