import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :mbta_v3_api,
  api_key: System.get_env("API_KEY"),
  api_url: System.get_env("API_URL"),
  req_plug: MBTAV3APITest.Plug
