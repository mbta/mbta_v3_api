# MBTAV3API

Client library for the [MBTA V3 API](https://www.mbta.com/developers/v3-api).

## Installation

The package can be installed by adding `mbta_v3_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mbta_v3_api, "~> 0.0.1"}
  ]
end
```

## Configuration

In your runtime configuration (`config/runtime.exs`) provide the API URL, key, and version (all required).

```elixir
config :v3_api,
  base_url: "API_URL",
  api_key: "API_KEY",
  api_version: "2021-01-09"
```

You can also set the following optional confuration values.

- `:cache_size` - Number of items to retain in the cache (_default:_ `10_000`)
- `:populate_caches?` - Whether to pre-populate route data in the cache (_default:_ `false`)

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/mbta_v3_api>.
