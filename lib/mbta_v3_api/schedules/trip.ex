defmodule MBTAV3API.Schedules.Trip do
  @moduledoc """
  Representation of GTFS trips.
  """

  alias MBTAV3API.RoutePatterns.RoutePattern
  alias MBTAV3API.Routes.Shape
  alias MBTAV3API.Vehicles.Vehicle

  @derive Jason.Encoder

  defstruct [
    :id,
    :name,
    :headsign,
    :direction_id,
    :shape_id,
    :route_pattern_id,
    :occupancy,
    bikes_allowed?: false
  ]

  @type id_t :: String.t()
  @type headsign :: String.t()
  @type direction_id_t :: 0 | 1
  @type t :: %__MODULE__{
          id: id_t,
          name: String.t(),
          headsign: headsign,
          direction_id: direction_id_t(),
          shape_id: Shape.id_t() | nil,
          route_pattern_id: RoutePattern.id_t() | nil,
          bikes_allowed?: boolean,
          occupancy: Vehicle.crowding() | nil
        }
end
