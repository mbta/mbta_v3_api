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
      RepoCache.Supervisor,
      Routes.Supervisor,
      MBTAV3API.Cache
    ]

    opts = [strategy: :one_for_one, name: MBTAV3API.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
