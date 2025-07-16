defmodule WeatherStation.WeatherStationFormatter do
  def format_state_result(%{
        "properties" => %{
          "relativeLocation" => %{"properties" => %{"city" => city, "state" => state}}
        }
      }) do
    IO.puts("Weather information for state: #{state}, city: #{city}")
  end

  def format_state_result(_), do: :error

  def format_weather_info(%{"properties" => %{"periods" => periods}}) do
    %{"name" => name, "temperature" => temperature, "temperatureUnit" => temperature_unit} =
      periods
      |> List.first()

    IO.puts("Temperature #{name} is #{temperature} #{temperature_unit}")
  end

  def format_weather_info(_), do: :error
end
