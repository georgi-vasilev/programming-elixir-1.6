defmodule Sequence.Application do
  use Application

  @impl true
  def start(_type, initial_number) do
    children = [
      {Sequence.Stash, initial_number},
      {Sequence.Server, nil}
    ]

    opts = [strategy: :rest_for_one, name: Sequence.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
