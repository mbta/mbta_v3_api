defmodule MBTAV3API.RoutePatterns.RepoApi do
  @moduledoc """
  Behavior for an API client for fetching route pattern data.
  """

  alias MBTAV3API.RoutePatterns.RoutePattern
  alias MBTAV3API.Routes.Route

  @doc """
  Return all route patterns for a route ID
  """
  @callback by_route_id(Route.id_t()) :: [RoutePattern.t()]
  @callback by_route_id(Route.id_t(), keyword()) :: [RoutePattern.t()]
end
