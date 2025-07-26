defmodule StackTest do
  use ExUnit.Case

  setup do
    Application.stop(:stack)
    Application.start(:stack)
    :ok
  end

  test "stash is initialized from applicatio env" do
    assert GenServer.call(Stack.Stash, {:get}) == Application.get_env(:stack, :initial_stack)
  end

  test "pushing and popping values" do
    Stack.push(:a)
    Stack.push(:b)

    assert Stack.pop() == :b
    assert Stack.pop() == :a
  end

  test "supervisor starts children" do
    children = Supervisor.which_children(Stack.Supervisor)
    sup_pid = Process.whereis(Stack.Supervisor)

    assert is_pid(sup_pid)
    assert Enum.count(children) == 2
    assert {:dictionary, _dict} = Process.info(Process.whereis(Stack.Supervisor), :dictionary)
  end
end
