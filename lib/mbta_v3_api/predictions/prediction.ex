defmodule MBTAV3API.Predictions.Prediction do
  @moduledoc """
  A prediction of when a vehicle will arrive at a stop.
  """

  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Schedules.Trip
  alias MBTAV3API.Stops.Stop
  alias MBTAV3API.Vehicles.Vehicle

  @derive Jason.Encoder

  defstruct id: nil,
            trip: nil,
            stop: nil,
            platform_stop_id: nil,
            route: nil,
            vehicle_id: nil,
            direction_id: nil,
            arrival_time: nil,
            departure_time: nil,
            time: nil,
            stop_sequence: 0,
            schedule_relationship: nil,
            track: nil,
            status: nil,
            departing?: false

  @type id_t :: String.t()
  @type schedule_relationship :: nil | :added | :unscheduled | :cancelled | :skipped | :no_data

  @typedoc "If the predicted stop has a parent stop (station), then that *may* be the stop set on the `stop` field. In some cases, it may contain a platform stop when the stop has a parent. The unmodified stop_id for the prediction can be found in the platform_stop_id field."
  @type stop :: Stop.t() | nil

  @type t :: %__MODULE__{
          id: id_t,
          trip: Trip.t() | nil,
          stop: stop,
          platform_stop_id: Stop.id_t() | nil,
          route: Route.t(),
          vehicle_id: Vehicle.id_t() | nil,
          direction_id: 0 | 1,
          arrival_time: DateTime.t() | nil,
          departure_time: DateTime.t() | nil,
          # TODO: Deprecated, should be removed in favor of arrival_time and departure_time -- MSS 2022-09-22
          time: DateTime.t() | nil,
          stop_sequence: non_neg_integer,
          schedule_relationship: schedule_relationship,
          track: String.t() | nil,
          status: String.t() | nil,
          departing?: boolean
        }
end
