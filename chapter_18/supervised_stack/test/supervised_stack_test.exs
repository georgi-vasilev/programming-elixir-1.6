defmodule SupervisedStackTest do
  use ExUnit.Case
  doctest SupervisedStack

  test "greets the world" do
    assert SupervisedStack.hello() == :world
  end
end
