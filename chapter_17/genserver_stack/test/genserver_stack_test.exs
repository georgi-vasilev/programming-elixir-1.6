defmodule GenserverStackTest do
  use ExUnit.Case
  doctest GenserverStack

  test "greets the world" do
    assert GenserverStack.hello() == :world
  end
end
