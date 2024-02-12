defmodule MBTAV3API.Trips do
  @moduledoc """
  Responsible for fetching Trip data from the MBTA V3 API.
  """
  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Schedules.Trip
  alias MBTAV3API.Trips.Parser

  def by_id(id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/trips/" <> id, opts)
  end

  def by_route(route_id, opts \\ []) do
    opts
    |> route_option(route_id)
    |> get_trips()
  end

  @spec by_route_and_directions(Route.id_t(), [Trip.direction_id_t()]) :: [Trip.t()]
  @spec by_route_and_directions(Route.id_t(), [Trip.direction_id_t()], keyword()) :: [Trip.t()]
  def by_route_and_directions(route_id, directions, opts \\ []) do
    opts
    |> route_option(route_id)
    |> direction_option(directions)
    |> get_trips()
    |> Map.get(:data, [])
    |> Enum.map(&Parser.parse/1)
  end

  @spec route_option(keyword(), Route.id_t()) :: keyword()
  defp route_option(opts, route_id), do: put_in(opts[:route], route_id)

  @spec direction_option(keyword(), [Trip.direction_id_t()]) :: keyword()
  defp direction_option(opts, [single_direction_id | []]),
    do: put_in(opts[:direction_id], single_direction_id)

  defp direction_option(opts, _both_directions), do: opts

  @spec get_trips(keyword()) :: JsonApi.t() | {:error, any}
  defp get_trips(opts) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/trips/", opts)
  end
end
