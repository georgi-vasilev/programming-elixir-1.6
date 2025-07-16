defmodule Issues.Cli do
  @default_count 4

  alias Issues.GithubIssues

  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions
  that end up generating a table of the last n issues in a github project
  """
  def run(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  Otherwise it is a github user name, project name, and (optionally) the number of entries to format.

  Return a tuple of `{user, project, count}`, or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
    |> process()
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | 4 ]
    """)

    System.halt(0)
  end

  def process({user, project, _count}) do
    GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn issue1, issue2 -> issue1["created_at"] >= issue2["created_at"] end)
  end

  defp args_to_internal_representation({[help: true], _, _}), do: :help

  defp args_to_internal_representation({_, [user, project, count], _}),
    do: {user, project, String.to_integer(count)}

  defp args_to_internal_representation({_, [user, project], _}),
    do: {user, project, @default_count}

  defp args_to_internal_representation(_), do: :help
end
