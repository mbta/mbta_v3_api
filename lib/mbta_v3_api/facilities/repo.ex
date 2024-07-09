defmodule MBTAV3API.Facilities.Repo do
  @moduledoc """
  Repo to get facilitiy information.
  """
  use RepoCache, ttl: :timer.hours(1)

  alias MBTAV3API.Facilities
  alias MBTAV3API.Facilities.Facility

  def get(id, opts \\ []) when is_binary(id) do
    case cache({id, opts}, fn {id, opts} ->
           with %{data: [facility]} <- Facilities.get(id, opts) do
             {:ok, facility}
           end
         end) do
      {:ok, facility} -> Facility.parse(facility)
      {:error, _} -> nil
    end
  end

  def get_excluded_stops(id) do
    %{properties: properties} = get(id, [])
    Enum.reduce(properties, [], fn %{name: name, value: value}, acc -> if name == "excludes-stop", do: [value | acc], else: acc end)
  end

  def get_for_stop(stop_id, opts \\ []) do
    facilities_filter_by_fn =
      Keyword.get(opts, :facilities_filter_by_fn, &Facilities.filter_by/1)

    cache(stop_id, fn stop_id ->
      facilities_filter_by_fn.([{"stop", stop_id}])
    end)
  end
end
