# MBTA

MBTA service API. https://www.mbta.com Source code: https://github.com/mbta/api

## Building

To install the required dependencies and to build the elixir project, run:

```console
mix local.hex --force
mix do deps.get, compile
```

## Installation

If [available in Hex][], the package can be installed by adding `mbta` to
your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:mbta, "~> 3.0"}]
end
```

Documentation can be generated with [ExDoc][] and published on [HexDocs][]. Once published, the docs can be found at
[https://hexdocs.pm/mbta][docs].

## Configuration

You can override the URL of your server (e.g. if you have a separate development and production server in your
configuration files).

```elixir
config :mbta, base_url: "http://localhost:4000"
```

Multiple clients for the same API with different URLs can be created passing different `base_url`s when calling
`MBTA.Connection.new/1`:

```elixir
client = MBTA.Connection.new(base_url: "http://localhost:4000")
```

## INSTRUCTIONS

Generate the SDK:

```bash
workspace/api% mix phx.swagger.generate
workspace/api% cd ..

workspace% openapi-generator generate -i ./api/apps/api_web/priv/static/swagger.json -g elixir -o sdk
workspace% cd sdk
```

Set the config:

```elixir
import Config

config :mbta, base_url: "https://api-dev.mbtace.com"

config :tesla, MBTA.Connection,
  middleware: [{Tesla.Middleware.Headers, [{"x-api-key", ""}]}]
```

Use it:

```bash
workspace/sdk% iex -S mix
```
```elixir
iex> client = MBTA.Connection.new()
iex> MBTA.Api.Stop.api_web_stop_controller_index(client, "page[offset]": 1)
```