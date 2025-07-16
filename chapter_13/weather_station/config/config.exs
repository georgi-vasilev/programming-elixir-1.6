import Config

config :weather_station, weather_station_url: "https://api.weather.gov"

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]
