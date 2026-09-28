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
end
