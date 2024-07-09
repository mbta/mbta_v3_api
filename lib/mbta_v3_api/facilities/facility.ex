defmodule MBTAV3API.Facilities.Facility do
  @moduledoc "Data model and helpers corresponding to the MBTA V3 API Facility resource."
  alias MBTAV3API.Stops.Stop
  alias JsonApi.Item

  defstruct id: nil,
            type: nil,
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
    short_name: String.t(),
    long_name: String.t(),
    stop: Stop.t(),
    latitude: number(),
    longitude: number(),
    properties: [
      facility_property_t
    ]
  }

  @spec parse(JsonApi.Item.t()) :: MBTAV3API.Facilities.Facility.t()
  def parse(%Item{id: id, attributes: attributes, relationships: relationships}) do
    %__MODULE__{
      id: id,
      type: attributes["type"],
      short_name: attributes["short_name"],
      long_name: attributes["long_name"],
      stop: parse_stop(relationships),
      properties: parse_properties(attributes["properties"])
    }
  end

  defp parse_properties(properties) do
    Enum.map(properties, &(%{name: &1["name"], value: &1["value"]}))
 end

  defp parse_stop(%{"stop" => [%{id: id, type: type}]}) do
    %Stop{id: id, type: type}
  end
end
