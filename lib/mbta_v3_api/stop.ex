defmodule MBTAV3API.Stop do
  use MBTAV3API.Schema

  alias MBTAV3API.EctoType

  embedded_schema do
    field(:address, :string)
    field(:at_street, :string)
    field(:description, :string)
    field(:latitude, :float)

    field(:location_type, EctoType.FlexEnum,
      values: [stop: 0, station: 1, entrance: 2, generic_node: 3]
    )

    field(:longitude, :float)
    field(:municipality, :string)
    field(:name, :string)
    field(:on_street, :string)
    field(:platform_name, :string)
    field(:platform_code, :string)

    field(:vehicle_type, EctoType.FlexEnum,
      values: [light_rail: 0, heavy_rail: 1, commuter_rail: 2, bus: 3, ferry: 4]
    )

    field(:wheelchair_boarding, EctoType.FlexEnum,
      values: [nil: 0, accessible: 1, inaccessible: 2]
    )

    has_many(:child_stops, __MODULE__, foreign_key: :parent_station_id)
    many_to_many(:connecting_stops, __MODULE__, join_through: "_")
    has_many(:facilities, MBTAV3API.Facility)
    belongs_to(:parent_station, __MODULE__)
  end

  @doc false
  def from_resource!(resource, included) do
    MBTAV3API.Schema.from_resource!(__MODULE__, resource, included)
  end
end
