defmodule MBTAV3API.Shapes do
  @moduledoc """
  Responsible for fetching Shape data from the MBTA V3 API.
  """

  def all(params \\ []) do
    {get_json_fn, params} = Keyword.pop(params, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/shapes/", params)
  end

  def by_id(id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/3)
    get_json_fn.("/shapes/#{id}", [], opts)
  end
end
