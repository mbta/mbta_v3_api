defmodule MBTAV3API.Trips do
  @moduledoc """
  Responsible for fetching Trip data from the MBTA V3 API.
  """

  def by_id(id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/trips/" <> id, opts)
  end

  def by_route(route_id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    opts = put_in(opts[:route], route_id)
    get_json_fn.("/trips/", opts)
  end
end
