defmodule MBTAV3API.Stops do
  @moduledoc """
  Responsible for fetching Stop data from the V3 API.
  """

  alias MBTAV3API.Stops.Stop

  @spec all(keyword()) :: JsonApi.t() | {:error, any}
  def all(opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/stops/", opts)
  end

  @spec filter_by([{String.t(), String.t()}], keyword()) :: JsonApi.t() | {:error, any}
  def filter_by(filters, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/3)

    params =
      Enum.map(filters, fn {k, v} ->
        {"filter[#{k}]", v}
      end)

    get_json_fn.("/stops/", params, opts)
  end

  @spec by_gtfs_id(Stop.id_t(), keyword(), keyword()) :: JsonApi.t() | {:error, any}
  def by_gtfs_id(gtfs_id, params \\ [], opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/3)
    get_json_fn.("/stops/#{gtfs_id}", params, opts)
  end
end
