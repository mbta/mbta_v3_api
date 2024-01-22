defmodule MBTAV3API.RoutePatterns.Repo do
  @moduledoc "Repo for fetching Route resources and their associated data from the V3 API."

  @behaviour MBTAV3API.RoutePatterns.RepoApi

  use RepoCache, ttl: :timer.hours(1)

  require Logger

  alias MBTAV3API.RoutePatterns
  alias MBTAV3API.RoutePatterns.RoutePattern

  @doc """
  Returns a single route pattern by ID
  """
  @callback get(RoutePattern.id_t()) :: RoutePattern.t() | nil
  @callback get(RoutePattern.id_t(), keyword()) :: RoutePattern.t() | nil
  def get(id, opts \\ []) when is_binary(id) do
    {route_patterns_get_fn, opts} =
      Keyword.pop(opts, :route_patterns_get_fn, &RoutePatterns.get/2)

    case cache({id, opts}, fn {id, opts} ->
           with %{data: [route_pattern]} <- route_patterns_get_fn.(id, opts) do
             {:ok, RoutePattern.new(route_pattern)}
           end
         end) do
      {:ok, route_pattern} -> route_pattern
      {:error, _} -> nil
    end
  end

  @impl RoutePatterns.RepoApi
  def by_route_id(route_id, opts \\ [])

  def by_route_id("Green", opts) do
    ~w(Green-B Green-C Green-D Green-E)s
    |> Enum.join(",")
    |> by_route_id(opts)
  end

  def by_route_id(route_id, opts) do
    opts
    |> Keyword.put(:route, route_id)
    |> Keyword.put(:sort, "typicality,sort_order")
    |> cache(&api_all/1)
    |> Enum.sort(&reorder_mrts(&1, &2, route_id))
  end

  def by_stop_id(stop_id, opts \\ []) do
    opts
    |> Keyword.put(:stop, stop_id)
    |> Keyword.put(:include, "representative_trip.shape,representative_trip.stops")
    |> cache(&api_all/1)
  end

  defp api_all(opts) do
    {route_patterns_all_fn, opts} =
      Keyword.pop(opts, :route_patterns_all_fn, &RoutePatterns.all/1)

    case route_patterns_all_fn.(opts) do
      {:error, error} ->
        _ =
          Logger.warning(
            "module=#{__MODULE__} RoutePatterns.all with opts #{inspect(opts)} returned :error -> #{inspect(error)}"
          )

        []

      %JsonApi{data: data} ->
        Enum.map(data, &RoutePattern.new/1)
    end
  end

  @spec reorder_mrts(RoutePattern.t(), RoutePattern.t(), String.t()) :: boolean()
  defp reorder_mrts(pattern_one, pattern_two, route_id) do
    not (pattern_one.route_id !== route_id and pattern_one.typicality == pattern_two.typicality)
  end
end
