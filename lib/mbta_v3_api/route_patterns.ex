defmodule MBTAV3API.RoutePatterns do
  @moduledoc """
  Responsible for fetching Route Pattern data from the V3 API.
  """

  alias MBTAV3API.Routes.Route

  @type api_response_t() :: JsonApi.t() | {:error, any}

  @spec all(Keyword.t()) :: api_response_t()
  def all(params \\ [], opts \\ []) do
    get_json_fn = Keyword.get(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/route_patterns/", params)
  end

  @spec get(Route.id_t(), keyword()) :: api_response_t()
  def get(id, opts \\ []) do
    get_json_fn = Keyword.get(opts, :get_json_fn, &MBTAV3API.get_json/1)
    get_json_fn.("/route_patterns/#{id}")
  end
end
