defmodule MBTAV3API do
  @moduledoc """
  Documentation for `MBTAV3API`.
  """
  alias MBTAV3API.JSONAPI

  @doc """
  Get an object by its ID.

  ## Examples

      iex> MBTAV3API.get!(MBTAV3API.Stop, "place-boyls")
      %MBTAV3API.Stop{
        id: "place-boyls",
        address: "Boylston St and Tremont St, Boston, MA",
        latitude: 42.35302,
        location_type: :station,
        longitude: -71.06459,
        municipality: "Boston",
        name: "Boylston",
        wheelchair_boarding: :inaccessible
      }

  """
  def get!(obj, id, opts \\ []) do
    %Req.Response{status: 200, body: %{} = resp_body} =
      Req.get!(req(),
        url:
          case obj do
            MBTAV3API.Stop -> "/stops/:id"
          end,
        params: Keyword.get(opts, :params, []),
        path_params: [id: id]
      )

    resp_jsonapi = JSONAPI.parse!(resp_body)

    JSONAPI.decode!(resp_jsonapi)
  end

  # Used for testing to mock out all API calls (should be nil)
  @req_plug Application.compile_env(:mbta_v3_api, :req_plug)

  defp req do
    Req.new(
      base_url: Application.get_env(:mbta_v3_api, :api_url, "https://api-v3.mbta.com"),
      headers: [accept: "application/vnd.api+json"],
      plug: @req_plug
    )
  end
end
