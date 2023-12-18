defmodule MBTAV3API.Stops do
  @moduledoc """
  Responsible for fetching Stop data from the V3 API.
  """

  alias Stops.Stop

  @spec all(keyword()) :: JsonApi.t() | {:error, any}
  def all(opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/stops/", opts)
  end

  @spec by_gtfs_id(Stop.id_t(), keyword(), keyword()) :: JsonApi.t() | {:error, any}
  def by_gtfs_id(gtfs_id, params \\ [], opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/3)
    get_json_fn.("/stops/#{gtfs_id}", params, opts)
  end
end
