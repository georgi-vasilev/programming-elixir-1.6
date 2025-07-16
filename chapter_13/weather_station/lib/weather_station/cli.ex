defmodule WeatherStation.Cli do
  alias WeatherStation.WeatherStationParser
  alias WeatherStation.WeatherStationFormatter

  def main(argv) do
    argv |> parse_args()
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> args_to_internal_representation()
    |> process()
  end

  def process(:help) do
    IO.puts("""
    usage: weather_station <latitude> <longititude>
    usage: weather_station <latitude>,<longititude>
    """)

    System.halt(0)
  end

  def process(coords) do
    coords
    |> process_state()
    |> process_weather()
  end

  defp process_state(coords) do
    state_info =
      coords
      |> WeatherStationParser.fetch_state_info()
      |> decode_response()

    WeatherStationFormatter.format_state_result(state_info)

    state_info
  end

  defp process_weather(url) do
    url
    |> WeatherStationParser.fetch_weather_info()
    |> decode_response()
    |> WeatherStationFormatter.format_weather_info()
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from National weather station: #{error["message"]}")
    System.halt(2)
  end

  defp args_to_internal_representation({[help: true], _, _}), do: :help

  defp args_to_internal_representation({_, [latitude, longititude], _}) do
    latitude <> "," <> longititude
  end

  defp args_to_internal_representation({_, [coords_string], _}) do
    [latitude, longitude] = String.split(coords_string, ",")
    latitude <> "," <> longitude
  end

  defp args_to_internal_representation(_), do: :help
end

