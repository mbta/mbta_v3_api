defmodule MBTAV3API.Facility do
  use MBTAV3API.Schema

  alias MBTAV3API.JSONAPI
  alias MBTAV3API.JSONAPI.Relationship

  embedded_schema do
    field(:latitude, :float)
    field(:long_name, :string)
    field(:longitude, :float)
    embeds_one(:properties, MBTAV3API.FacilityProperties)
    field(:short_name, :string)

    field(:type, Ecto.Enum,
      values: [
        :bike_storage,
        :bridge_plate,
        :electric_car_chargers,
        :elevated_subplatform,
        :elevator,
        :escalator,
        :fare_media_assistance_facility,
        :fare_media_assistant,
        :fare_vending_machine,
        :fare_vending_retailer,
        :fully_elevated_platform,
        :other,
        :parking_area,
        :pick_drop,
        :portable_boarding_lift,
        :ramp,
        :taxi_stand,
        :ticket_window
      ]
    )

    belongs_to(:stop, MBTAV3API.Stop)
  end

  @doc false
  def from_resource!(
        %JSONAPI.Resource{
          type: "facility",
          id: id,
          attributes: attributes,
          relationships: relationships
        },
        included
      ) do
    %__MODULE__{
      id: id,
      latitude: attributes["latitude"],
      long_name: attributes["long_name"],
      longitude: attributes["longitude"],
      properties: MBTAV3API.FacilityProperties.parse!(attributes["properties"]),
      short_name: attributes["short_name"],
      type: parse_type!(attributes["type"]),
      stop_id: Relationship.id(relationships["stop"])
    }
    |> Relationship.unpack(relationships, :stop, included)
  end

  defp parse_type!(value) do
    {:parameterized, Ecto.Enum, params} = __schema__(:type, :type)

    {:ok, type} =
      value
      |> String.downcase()
      |> then(&Ecto.Enum.cast(&1, params))

    type
  end
end
