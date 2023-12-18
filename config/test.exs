import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :mbta_v3_api, :req_plug, MBTAV3APITest.Plug
