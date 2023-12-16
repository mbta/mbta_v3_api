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
end
