defmodule MBTAV3API.Schedules.Schedule do
  @moduledoc """
  Representation of GTFS schedules.
  """

  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Schedules.Trip
  alias MBTAV3API.Stops.Stop

  @derive Jason.Encoder

  defstruct route: nil,
            trip: nil,
            stop: nil,
            arrival_time: nil,
            departure_time: nil,
            time: nil,
            flag?: false,
            early_departure?: false,
            last_stop?: false,
            stop_sequence: 0,
            pickup_type: 0,
            platform_stop_id: nil

  @typedoc "If the scheduled stop has a parent stop (station), then the `stop` field will contain that parent stop. Otherwise it will contain the scheduled platform stop. Whether or not the stop has a parent, the unmodified stop id can be found in platform_stop_id field."
  @type stop :: Stop.t()

  @type t :: %__MODULE__{
          route: Route.t(),
          trip: Trip.t(),
          stop: stop,
          arrival_time: DateTime.t() | nil,
          departure_time: DateTime.t() | nil,
          time: DateTime.t(),
          flag?: boolean,
          early_departure?: boolean,
          last_stop?: boolean,
          stop_sequence: non_neg_integer,
          pickup_type: integer,
          platform_stop_id: Stop.id_t()
        }

  def flag?(%__MODULE__{flag?: value}), do: value

  def no_times?(%__MODULE__{arrival_time: at, departure_time: dt}),
    do: is_nil(at) and is_nil(dt)
end

defmodule Schedules.ScheduleCondensed do
  @moduledoc """
  Lightweight alternate to Schedule.t()
  """

  defstruct stop_id: nil,
            time: nil,
            trip_id: nil,
            route_pattern_id: nil,
            train_number: nil,
            stop_sequence: 0,
            headsign: nil

  @type t :: %__MODULE__{
          stop_id: String.t(),
          time: DateTime.t(),
          trip_id: String.t(),
          route_pattern_id: String.t() | nil,
          train_number: String.t() | nil,
          stop_sequence: non_neg_integer,
          headsign: String.t()
        }
end
