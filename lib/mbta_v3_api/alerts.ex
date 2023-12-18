defmodule MBTAV3API.Alerts do
  @moduledoc """
  Fetch Alert data from the MBTA V3 API.
  """

  @spec all() :: JsonApi.t() | {:error, any}
  def all(opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/alerts/", opts)
  end
end
