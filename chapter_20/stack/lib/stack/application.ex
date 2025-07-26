defmodule Stack.Application do
  use Application

  @impl true
  def start(_type, _args) do
    initial_stack = Application.get_env(:stack, :initial_stack)

    children = [
      {Stack.Stash, initial_stack},
      Stack.Server
    ]

    opts = [strategy: :one_for_one, name: Stack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

