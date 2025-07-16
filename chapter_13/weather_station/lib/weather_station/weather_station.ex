defmodule WeatherStation.WeatherStationParser do
  require Logger

  @user_agent [{"User-agent", "Elixir gvasilevv@hey.me"}]
  @weather_station_url Application.compile_env(:weather_station, :weather_station_url)

  def fetch_state_info(coords) do
    coords
    |> weather_station_url()
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def fetch_weather_info(%{"properties" => %{"forecast" => forecast_url}}) do
    forecast_url
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def fetch_weather_info(_), do: :error

  def weather_station_url(coords) do
    "#{@weather_station_url}/points/#{coords}"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.debug(fn -> inspect(body) end)

    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
