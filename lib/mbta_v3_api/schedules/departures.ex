defmodule MBTAV3API.Schedules.Departures do
  @moduledoc """
  Departure information for a schedule.
  """

  @derive Jason.Encoder

  @enforce_keys [:first_departure, :last_departure]

  defstruct [
    :first_departure,
    :last_departure,
    :stop_name,
    :stop_id,
    :parent_stop_id,
    :is_terminus,
    :latitude,
    :longitude
  ]

  @type t :: %__MODULE__{
          first_departure: DateTime.t(),
          last_departure: DateTime.t(),
          stop_id: Stops.Stop.id_t() | nil,
          parent_stop_id: Stops.Stop.id_t() | nil,
          stop_name: String.t() | nil,
          is_terminus: boolean() | nil,
          latitude: float(),
          longitude: float()
        }
end
