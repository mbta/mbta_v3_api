defmodule MBTAV3API.Facilities.Facility do
  @moduledoc "Data model and helpers corresponding to the MBTA V3 API Facility resource."
  alias MBTAV3API.Stops.Stop
  alias JsonApi.Item

  defstruct id: "",
            type: "",
            short_name: nil,
            long_name: nil,
            stop: nil,
            latitude: nil,
            longitude: nil,
            properties: []

  @type id_t :: String.t()
  @type facility_property_t :: %{name: String.t(), value: String.t()}

  @type t :: %__MODULE__{
          id: id_t,
          type: String.t(),
          short_name: String.t() | nil,
          long_name: String.t() | nil,
          stop: Stop.t() | nil,
          latitude: number() | nil,
          longitude: number() | nil,
          properties: [
            facility_property_t
          ]
        }

  @spec parse(Item.t()) :: t()
  def parse(%Item{id: id, attributes: attributes, relationships: relationships}) do
    %__MODULE__{
      id: id,
      type: attributes["type"],
      short_name: attributes["short_name"],
      long_name: attributes["long_name"],
      stop: parse_stop(relationships),
      properties: parse_properties(attributes["properties"]),
      latitude: attributes["latitude"],
      longitude: attributes["longitude"]
    }
  end

  defp parse_properties(properties) do
    Enum.map(properties, &%{name: &1["name"], value: &1["value"]})
  end

  defp parse_stop(%{"stop" => [%{id: id, attributes: attributes}]}) do
    %Stop{id: id, name: attributes["name"]}
  end

  defp parse_stop(%{"stop" => [%{id: id}]}) do
    %Stop{id: id}
  end

  defp parse_stop(%{"stop" => []}), do: nil
end
