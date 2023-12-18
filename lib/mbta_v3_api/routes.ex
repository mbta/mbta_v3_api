defmodule MBTAV3API.Routes do
  @moduledoc """
  Responsible for fetching Route data from the MBTA V3 API.
  """
  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Stops.Stop

  @type api_response_t() :: JsonApi.t() | {:error, any}

  @spec all(keyword()) :: api_response_t()
  def all(opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/routes/", opts)
  end

  @spec get(Route.id_t(), keyword()) :: api_response_t()
  def get(id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/routes/#{id}", opts)
  end

  @spec by_type(Route.type_int(), keyword()) :: api_response_t()
  def by_type(type, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    opts = put_in(opts[:type], type)
    get_json_fn.("/routes/", opts)
  end

  @spec by_stop(Stop.id_t(), keyword()) :: api_response_t()
  def by_stop(stop_id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    opts = put_in(opts[:stop], stop_id)
    get_json_fn.("/routes/", opts)
  end

  @spec by_stop_and_direction(Stop.id_t(), 0 | 1, keyword()) :: api_response_t()
  def by_stop_and_direction(stop_id, direction_id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    opts = put_in(opts[:stop], stop_id)
    opts = put_in(opts[:direction_id], direction_id)
    get_json_fn.("/routes/", opts)
  end
end
