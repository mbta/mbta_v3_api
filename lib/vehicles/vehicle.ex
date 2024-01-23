defmodule MBTAV3API.Vehicles.Vehicle do
  @moduledoc """
  Representation of a vehicle, e.g. train or bus.
  """

  defstruct [
    :id,
    :route_id,
    :trip_id,
    :shape_id,
    :stop_id,
    :direction_id,
    :longitude,
    :latitude,
    :status,
    :bearing,
    :crowding
  ]

  @type status :: :in_transit | :stopped | :incoming
  @type crowding :: :not_crowded | :some_crowding | :crowded

  @type id_t :: String.t()

  @type t :: %__MODULE__{
          id: id_t(),
          route_id: String.t() | nil,
          trip_id: String.t() | nil,
          shape_id: String.t() | nil,
          stop_id: String.t() | nil,
          direction_id: 0 | 1,
          longitude: float,
          latitude: float,
          bearing: non_neg_integer,
          status: status,
          crowding: crowding | nil
        }
end
