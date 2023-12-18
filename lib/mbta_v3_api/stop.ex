defmodule MBTAV3API.Stop do
  use MBTAV3API.Schema

  alias MBTAV3API.JSONAPI
  alias MBTAV3API.JSONAPI.Relationship

  embedded_schema do
    field(:address, :string)
    field(:at_street, :string)
    field(:description, :string)
    field(:latitude, :float)
    field(:location_type, Ecto.Enum, values: [:stop, :station, :entrance, :generic_node])
    field(:longitude, :float)
    field(:municipality, :string)
    field(:name, :string)
    field(:on_street, :string)
    field(:platform_name, :string)
    field(:platform_code, :string)

    field(:vehicle_type, Ecto.Enum,
      values: [:light_rail, :heavy_rail, :commuter_rail, :bus, :ferry]
    )

    field(:wheelchair_boarding, Ecto.Enum, values: [:accessible, :inaccessible])

    has_many(:child_stops, __MODULE__, foreign_key: :parent_station_id)
    many_to_many(:connecting_stops, __MODULE__, join_through: "_")
    has_many(:facilities, MBTAV3API.Facility)
    belongs_to(:parent_station, __MODULE__)
  end

  @doc false
  def from_resource!(
        %JSONAPI.Resource{
          type: "stop",
          id: id,
          attributes: attributes,
          relationships: relationships
        },
        included
      ) do
    %__MODULE__{
      id: id,
      address: attributes["address"],
      at_street: attributes["at_street"],
      description: attributes["description"],
      latitude: attributes["latitude"],
      location_type: parse_location_type!(attributes["location_type"]),
      longitude: attributes["longitude"],
      municipality: attributes["municipality"],
      name: attributes["name"],
      on_street: attributes["on_street"],
      platform_name: attributes["platform_name"],
      platform_code: attributes["platform_code"],
      vehicle_type: parse_vehicle_type!(attributes["vehicle_type"]),
      wheelchair_boarding: parse_wheelchair_boarding!(attributes["wheelchair_boarding"]),
      parent_station_id: Relationship.id(relationships["parent_station"])
    }
    |> Relationship.unpack(relationships, :child_stops, included)
    |> Relationship.unpack(relationships, :connecting_stops, included)
    |> Relationship.unpack(relationships, :facilities, included)
    |> Relationship.unpack(relationships, :parent_station, included)
  end

  defp parse_location_type!(0), do: :stop
  defp parse_location_type!(1), do: :station
  defp parse_location_type!(2), do: :entrance
  defp parse_location_type!(3), do: :generic_node

  defp parse_vehicle_type!(0), do: :light_rail
  defp parse_vehicle_type!(1), do: :heavy_rail
  defp parse_vehicle_type!(2), do: :commuter_rail
  defp parse_vehicle_type!(3), do: :bus
  defp parse_vehicle_type!(4), do: :ferry
  defp parse_vehicle_type!(nil), do: nil

  defp parse_wheelchair_boarding!(0), do: nil
  defp parse_wheelchair_boarding!(1), do: :accessible
  defp parse_wheelchair_boarding!(2), do: :inaccessible
end
