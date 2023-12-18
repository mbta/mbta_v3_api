defmodule MBTAV3API.Stops.Repo do
  @moduledoc """
  Matches the Ecto API, but fetches Stops from the Stop Info API instead.
  """
  use RepoCache, ttl: :timer.hours(1)

  alias MBTAV3API.Routes.Repo, as: RoutesRepo
  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Stops.{Api, Stop}

  @type stop_feature ::
          Route.route_type()
          | Route.subway_lines_type()
          | :access
          | :parking_lot
          | :"Green-B"
          | :"Green-C"
          | :"Green-D"
          | :"Green-E"
  @type stops_response :: [Stop.t()] | {:error, any}
  @type stop_by_route :: (Route.id_t(), 0 | 1, Keyword.t() -> stops_response)

  @spec get(Stop.id_t()) :: Stop.t() | nil
  @spec get(Stop.id_t(), keyword()) :: Stop.t() | nil
  def get(id, opts \\ []) when is_binary(id) do
    case stop(id, opts) do
      {:ok, s} -> s
      _ -> nil
    end
  end

  @spec get!(Stop.id_t()) :: Stop.t()
  @spec get!(Stop.id_t(), keyword()) :: Stop.t()
  def get!(id, opts \\ []) do
    case stop(id, opts) do
      {:ok, %Stop{} = s} -> s
      _ -> raise Stops.NotFoundError, message: "Could not find stop #{id}"
    end
  end

  @spec has_parent?(Stop.t() | nil) :: boolean
  def has_parent?(nil), do: false
  def has_parent?(%Stop{parent_id: nil}), do: false
  def has_parent?(%Stop{parent_id: _}), do: true

  @spec get_parent(Stop.t() | Stop.id_t() | nil) :: Stop.t() | nil
  @spec get_parent(Stop.t() | Stop.id_t() | nil, keyword()) :: Stop.t() | nil
  def get_parent(stop, opts \\ [])
  def get_parent(nil, _opts), do: nil

  def get_parent(%Stop{parent_id: nil} = stop, _opts) do
    stop
  end

  def get_parent(%Stop{parent_id: parent_id}, opts) when is_binary(parent_id) do
    case stop(parent_id, opts) do
      {:ok, %Stop{} = stop} -> stop
      _ -> nil
    end
  end

  def get_parent(id, opts) when is_binary(id) do
    id
    |> get(opts)
    |> get_parent(opts)
  end

  @spec stop(Stop.id_t(), keyword()) :: {:ok, Stop.t() | nil} | {:error, any}
  def stop(id, opts) do
    stops_by_gtfs_id_fn = Keyword.get(opts, :stops_by_gtfs_id_fn, &Api.by_gtfs_id/1)

    # the `cache` macro uses the function name as part of the key, and :stop
    # makes more sense for this than :get, since other functions in this
    # module will be working with those cache rows as well.
    cache(id, stops_by_gtfs_id_fn)
  end

  @spec by_route(Route.id_t(), 0 | 1) :: stops_response()
  @spec by_route(Route.id_t(), 0 | 1, Keyword.t()) :: stops_response()
  def by_route(route_id, direction_id, opts \\ []) do
    {by_route_fn, opts} = Keyword.pop(opts, :by_route_fn, &Api.by_route/1)

    cache({route_id, direction_id, opts}, fn args ->
      with stops when is_list(stops) <- by_route_fn.(args) do
        for stop <- stops do
          # Put the stop in the cache under {:stop, id} key as well so it will
          # also be cached for Stops.Repo.get/1 calls
          ConCache.put(__MODULE__, {:stop, stop.id}, {:ok, stop})
          stop
        end
      end
    end)
  end

  @spec by_route_type(Route.route_type()) :: stops_response()
  @spec by_route_type(Route.route_type(), Keyword.t()) :: stops_response()
  def by_route_type(route_type, opts \\ []) do
    {by_route_type_fn, opts} = Keyword.pop(opts, :by_route_type_fn, &Api.by_route_type/1)

    cache(
      {route_type, opts},
      fn stop ->
        stop
        |> by_route_type_fn.()
        |> Enum.map(&get_parent/1)
        |> Enum.uniq_by(& &1.id)
      end
    )
  end

  @spec by_trip(Trip.id_t()) :: [Stop.t()]
  @spec by_trip(Trip.id_t(), keyword()) :: [Stop.t()]
  def by_trip(trip_id, opts \\ []) do
    by_trip_fn = Keyword.get(opts, :by_trip_fn, &Api.by_trip/1)
    cache(trip_id, by_trip_fn)
  end

  def stop_exists_on_route?(stop_id, route, direction_id) do
    route
    |> by_route(direction_id)
    |> Enum.any?(&(&1.id == stop_id))
  end

  @doc """
  Returns a list of the features associated with the given stop
  """
  @spec stop_features(Stop.t(), Keyword.t()) :: [stop_feature]
  def stop_features(%Stop{} = stop, opts \\ []) do
    excluded = Keyword.get(opts, :exclude, [])

    [
      route_features(stop.id, opts),
      parking_features(stop.parking_lots),
      accessibility_features(stop.accessibility)
    ]
    |> Enum.concat()
    |> Enum.reject(&(&1 in excluded))
    |> Enum.sort_by(&sort_feature_icons/1)
  end

  defp parking_features([]), do: []
  defp parking_features(_parking_lots), do: [:parking_lot]

  @spec route_features(String.t(), Keyword.t()) :: [stop_feature]
  defp route_features(stop_id, opts) do
    icon_fn =
      if Keyword.get(opts, :expand_branches?) do
        &branch_feature/1
      else
        &Route.icon_atom/1
      end

    opts
    |> Keyword.get(:connections)
    |> get_stop_connections(stop_id)
    |> Enum.map(icon_fn)
    |> Enum.uniq()
  end

  @spec get_stop_connections([Route.t()] | {:error, :not_fetched} | nil, Stop.id_t()) ::
          [Route.t()]
  defp get_stop_connections(connections, _stop_id) when is_list(connections) do
    connections
  end

  defp get_stop_connections(_, stop_id) do
    RoutesRepo.by_stop(stop_id)
  end

  def branch_feature(%Route{id: "Green-B"}), do: :"Green-B"
  def branch_feature(%Route{id: "Green-C"}), do: :"Green-C"
  def branch_feature(%Route{id: "Green-D"}), do: :"Green-D"
  def branch_feature(%Route{id: "Green-E"}), do: :"Green-E"
  def branch_feature(route), do: Route.icon_atom(route)

  @spec accessibility_features([String.t()]) :: [:access]
  defp accessibility_features(["accessible" | _]), do: [:access]
  defp accessibility_features(_), do: []

  @spec sort_feature_icons(atom) :: integer
  defp sort_feature_icons(:"Green-B"), do: 0
  defp sort_feature_icons(:"Green-C"), do: 1
  defp sort_feature_icons(:"Green-D"), do: 2
  defp sort_feature_icons(:"Green-E"), do: 3
  defp sort_feature_icons(:bus), do: 5
  defp sort_feature_icons(:commuter_rail), do: 6
  defp sort_feature_icons(:access), do: 7
  defp sort_feature_icons(:parking_lot), do: 8
  defp sort_feature_icons(_), do: 4
end

defmodule Stops.NotFoundError do
  @moduledoc "Raised when we don't find a stop with the given GTFS ID"
  defexception [:message]
end
