defmodule MBTAV3API.JSONAPI do
  @moduledoc false
  alias MBTAV3API.JSONAPI.Included
  alias MBTAV3API.JSONAPI.Error
  alias MBTAV3API.JSONAPI.Links
  alias MBTAV3API.JSONAPI.Resource
  alias MBTAV3API.JSONAPI.ResourceIdentifier

  @typep resource_or_identifier :: Resource.t() | ResourceIdentifier.t()

  @type t :: %__MODULE__{
          data: resource_or_identifier() | list(resource_or_identifier()) | nil,
          errors: list(Error.t()) | nil,
          links: Links.t() | nil,
          included: list(Resource.t()) | nil
        }

  defstruct [:data, :errors, :links, :included]

  @spec parse!(map()) :: t()
  def parse!(data) do
    %__MODULE__{
      data: parse_data!(data["data"]),
      errors: parse_errors!(data["errors"]),
      links: parse_links!(data["links"]),
      included: parse_included!(data["included"])
    }
  end

  @spec decode!(t()) :: term()
  def decode!(%__MODULE__{data: %Resource{} = resource, included: included}) do
    included = Included.start(included, [resource])

    result = Resource.decode!(resource, included)

    Included.stop(included)

    result
  end

  @type include_arg :: atom() | list(atom() | {atom, include_arg()})

  @doc """
  Turns an include option into a correctly formatted query parameter.

  ## Examples

      iex> MBTAV3API.JSONAPI.include(:connecting_stops)
      "connecting_stops"

      iex> MBTAV3API.JSONAPI.include(parent_station: :connecting_stops)
      "parent_station,parent_station.connecting_stops"

      iex> MBTAV3API.JSONAPI.include([:facilities, connecting_stops: [:child_stops, parent_station: :facilities]])
      "facilities,connecting_stops,connecting_stops.child_stops,connecting_stops.parent_station,connecting_stops.parent_station.facilities"
  """
  @spec include(include_arg()) :: String.t()
  def include(rels) do
    flatten_include(rels)
    |> List.wrap()
    |> Enum.join(",")
  end

  defp parse_data!(nil), do: nil

  defp parse_data!(data) when is_map(data) do
    if Map.has_key?(data, "attributes") or Map.has_key?(data, "relationships") or
         Map.has_key?(data, "links") do
      Resource.parse!(data)
    else
      ResourceIdentifier.parse!(data)
    end
  end

  defp parse_errors!(nil), do: nil
  defp parse_links!(nil), do: nil
  defp parse_included!(nil), do: nil

  defp parse_included!(data) when is_list(data) do
    Enum.map(data, &Resource.parse!/1)
  end

  defp flatten_include(rel) when is_atom(rel), do: to_string(rel)

  defp flatten_include({rel, subrel}) when is_atom(rel) do
    flatten_include(subrel)
    |> List.wrap()
    |> then(fn subrel ->
      Enum.concat([rel], Enum.map(subrel, &"#{rel}.#{&1}"))
    end)
  end

  defp flatten_include(rels) when is_list(rels) do
    Enum.flat_map(rels, &List.wrap(flatten_include(&1)))
  end
end
