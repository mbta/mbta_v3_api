defmodule MBTAV3API.Schedules do
  @moduledoc """
  Responsible for fetching Schedule data from the MBTA V3 API.
  """

  def all(params \\ [], opts \\ []) do
    get_json_fn = Keyword.get(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/schedules/", params)
  end
end
