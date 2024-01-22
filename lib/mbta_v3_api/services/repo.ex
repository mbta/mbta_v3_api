defmodule MBTAV3API.Services.Repo do
  @moduledoc """
  Retrieves services for a route.
  """

  use RepoCache, ttl: :timer.hours(1)

  alias MBTAV3API.Services
  alias MBTAV3API.Services.Service

  def by_id(id, opts \\ []) when is_binary(id) do
    services_get_fn =
      Keyword.get(opts, :services_get_fn, &Services.get/1)

    cache(id, fn _ ->
      id
      |> services_get_fn.()
      |> handle_response()
    end)
    |> List.first()
  end

  def by_route_id(route_id, params \\ [], opts \\ [])

  def by_route_id([route_id] = route, params, opts) when is_list(route) do
    by_route_id(route_id, params, opts)
  end

  def by_route_id("Green", params, opts) do
    "Green-B,Green-C,Green-D,Green-E"
    |> by_route_id(params, opts)
  end

  def by_route_id(route_id, params, opts) when is_binary(route_id) do
    services_all_fn =
      Keyword.get(opts, :services_all_fn, &Services.all/1)

    cache({route_id, params}, fn _ ->
      params
      |> Keyword.put(:route, route_id)
      |> services_all_fn.()
      |> handle_response()
    end)
  end

  defp handle_response(%JsonApi{data: data}) do
    Enum.map(data, &Service.new/1)
  end

  defp handle_response({:error, [%JsonApi.Error{code: "not_found"}]}) do
    []
  end
end
