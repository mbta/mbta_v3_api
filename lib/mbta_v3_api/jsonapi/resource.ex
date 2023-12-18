defmodule MBTAV3API.JSONAPI.Resource do
  alias MBTAV3API.JSONAPI.Included
  alias MBTAV3API.JSONAPI.Links
  alias MBTAV3API.JSONAPI.Relationship

  @type t :: %__MODULE__{
          type: String.t(),
          id: String.t(),
          attributes: term() | nil,
          relationships: %{String.t() => Relationship.t()} | nil,
          links: Links.t() | nil
        }

  defstruct [:type, :id, :attributes, :relationships, :links]

  @spec parse!(term()) :: t()
  def parse!(data) do
    %__MODULE__{
      type: data["type"],
      id: data["id"],
      attributes: data["attributes"],
      relationships: parse_relationships!(data["relationships"]),
      links: Links.parse!(data["links"])
    }
  end

  @spec decode!(t(), Included.t()) :: term()
  def decode!(resource, included) do
    case resource.type do
      "alert" -> MBTAV3API.Alert.from_resource!(resource, included)
      "facility" -> MBTAV3API.Facility.from_resource!(resource, included)
      "stop" -> MBTAV3API.Stop.from_resource!(resource, included)
    end
  end

  defp parse_relationships!(nil), do: nil

  defp parse_relationships!(data) do
    data
    |> Map.new(fn {k, v} -> {k, Relationship.parse!(v)} end)
  end
end
