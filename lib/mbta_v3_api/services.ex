defmodule MBTAV3API.Services do
  @moduledoc """
  Fetch Service data from the MBTA V3 API.
  """

  def all(params \\ []) do
    {get_json_fn, params} = Keyword.pop(params, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/services/", params)
  end

  def get(id, params \\ []) do
    {get_json_fn, params} = Keyword.pop(params, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/services/#{id}", params)
  end

  @spec by_ids(list() | binary(), keyword(), keyword()) :: JsonApi.t() | {:error, any}
  def by_ids(ids, params \\ [], opts \\ [])

  def by_ids(ids, params, opts) when is_list(ids) do
    by_ids(Enum.join(ids, ","), params, opts)
  end

  def by_ids(ids, params, opts) do
    params = Keyword.put(params, :"filter[id]", ids)
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/3)
    get_json_fn.("/services/", params, opts)
  end
end
