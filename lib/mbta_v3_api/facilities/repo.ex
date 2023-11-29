defmodule MBTAV3API.Facilities.Repo do
  @moduledoc """
  Repo to get facilitiy information.
  """
  use RepoCache, ttl: :timer.hours(1)

  alias MBTAV3API.Facilities

  def get_for_stop(stop_id, opts \\ []) do
    facilities_filter_by_fn =
      Keyword.get(opts, :facilities_filter_by_fn, &Facilities.filter_by/1)

    cache(stop_id, fn stop_id ->
      facilities_filter_by_fn.([{"stop", stop_id}])
    end)
  end
end
