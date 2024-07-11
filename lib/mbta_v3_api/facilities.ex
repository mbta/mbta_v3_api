defmodule MBTAV3API.Facilities do
  @moduledoc """
  Fetch Facilities data from the MBTA V3 API.
  """

  @type api_response_t() :: JsonApi.t() | {:error, String.t()}

  def all(params \\ [], opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/3)
    get_json_fn.("/facilities/", params, opts)
  end

  def filter_by(filters, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/3)

    params =
      Enum.map(filters, fn {k, v} ->
        {"filter[#{k}]", v}
      end)

    get_json_fn.("/facilities/", params, opts)
  end

  @spec get(String.t(), keyword()) :: api_response_t()
  def get(id, opts \\ []) do
    {get_json_fn, opts} = Keyword.pop(opts, :get_json_fn, &MBTAV3API.get_json/2)
    get_json_fn.("/facilities/#{id}", opts)
  end
end
