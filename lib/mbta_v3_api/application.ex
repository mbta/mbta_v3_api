defmodule MBTAV3API.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ConCache,
       name: MBTAV3API.Cache.Backend,
       ttl_check_interval: :timer.seconds(1),
       global_ttl: :timer.hours(24)},
      MBTAV3API.Cache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MBTAV3API.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
