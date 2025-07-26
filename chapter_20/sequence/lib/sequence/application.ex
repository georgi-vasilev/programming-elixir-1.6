defmodule Sequence.Application do
  use Application

  @impl true
  def start(_type, _args) do
    initial_number = Application.get_env(:sequence, :initial_number)
    children = [
      {Sequence.Stash, initial_number},
      {Sequence.Server, nil}
    ]

    opts = [strategy: :rest_for_one, name: Sequence.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
