defmodule MBTAV3API.Application do
  @moduledoc """
  Start the supervision tree for the application.
  """
  use Application

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      %{
        id: ConCache,
        start:
          {ConCache, :start_link,
           [
             [
               ttl: :timer.seconds(60),
               ttl_check: :timer.seconds(5),
               ets_options: [read_concurrency: true]
             ],
             [name: :line_diagram_realtime_cache]
           ]}
      },
      RepoCache.Log,
      MBTAV3API.Cache,
      MBTAV3API.Schedules.Repo,
      MBTAV3API.Facilities.Repo,
      MBTAV3API.Stops.Repo,
      MBTAV3API.Routes.Supervisor,
      MBTAV3API.Services.Repo,
      MBTAV3API.RoutePatterns.Repo,
      MBTAV3API.Predictions.Supervisor
    ]

    opts = [strategy: :one_for_one, name: MBTAV3API.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
