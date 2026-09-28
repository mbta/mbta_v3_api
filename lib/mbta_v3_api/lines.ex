defmodule MBTAV3API.Lines do
  @moduledoc """
  Fetch Line data from the MBTA V3 API.
  """

  def all(params \\ []) do
    {get_json_fn, params} = Keyword.pop(params, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/lines/", params)
  end

  def get(id, params \\ []) do
    {get_json_fn, params} = Keyword.pop(params, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/lines/#{id}", params)
  end
end
