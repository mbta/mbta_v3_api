import Config

config :mbta, base_url: "https://api-dev.mbtace.com"

config :tesla, MBTA.Connection, middleware: [{Tesla.Middleware.Headers, [{"x-api-key", ""}]}]
