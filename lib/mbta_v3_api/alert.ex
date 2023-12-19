defmodule MBTAV3API.Alert do
  use MBTAV3API.Schema

  alias MBTAV3API.EctoType

  embedded_schema do
    embeds_many :active_period, ActivePeriod, primary_key: false do
      field(:start, EctoType.EasternDatetime)
      field(:end, EctoType.EasternDatetime)
    end

    field(:banner, :string)

    field(:cause, EctoType.FlexEnum,
      values: [
        :accident,
        :amtrak,
        :an_earlier_mechanical_problem,
        :an_earlier_signal_problem,
        :autos_impeding_service,
        :coast_guard_restriction,
        :congestion,
        :construction,
        :crossing_malfunction,
        :demonstration,
        :disabled_bus,
        :disabled_train,
        :drawbridge_being_raised,
        :electrical_work,
        :fire,
        :fog,
        :freight_train_interference,
        :hazmat_condition,
        :heavy_ridership,
        :high_winds,
        :holiday,
        :hurricane,
        :ice_in_harbor,
        :maintenance,
        :mechanical_problem,
        :medical_emergency,
        :parade,
        :police_action,
        :power_problem,
        :severe_weather,
        :signal_problem,
        :slippery_rail,
        :snow,
        :special_event,
        :speed_restriction,
        :switch_problem,
        :tie_replacement,
        :track_problem,
        :track_work,
        :traffic,
        :unknown_cause,
        :unruly_passenger,
        :weather
      ]
    )

    field(:created_at, EctoType.EasternDatetime)
    field(:description, :string)

    field(:effect, EctoType.FlexEnum,
      values: [
        :access_issue,
        :additional_service,
        :amber_alert,
        :bike_issue,
        :cancellation,
        :delay,
        :detour,
        :dock_closure,
        :dock_issue,
        :elevator_closure,
        :escalator_closure,
        :extra_service,
        :facility_issue,
        :modified_service,
        :no_service,
        :other_effect,
        :parking_closure,
        :parking_issue,
        :policy_change,
        :schedule_change,
        :service_change,
        :shuttle,
        :snow_route,
        :station_closure,
        :station_issue,
        :stop_closure,
        :stop_move,
        :stop_moved,
        :summary,
        :suspension,
        :track_change,
        :unknown_effect
      ]
    )

    field(:effect_name, :string)
    field(:header, :string)
    field(:image, :string)
    field(:image_alternative_text, :string)

    embeds_many :informed_entity, InformedEntity, primary_key: false do
      field(:activities, {:array, EctoType.FlexEnum},
        values: [
          :board,
          :bringing_bike,
          :exit,
          :park_car,
          :ride,
          :store_bike,
          :using_escalator,
          :using_wheelchair
        ]
      )

      field(:direction_id, :integer)
      field(:facility, :string)
      field(:route, :string)

      field(:route_type, EctoType.FlexEnum,
        values: [light_rail: 0, heavy_rail: 1, commuter_rail: 2, bus: 3, ferry: 4]
      )

      field(:stop, :string)
      field(:trip, :string)
    end

    field(:lifecycle, EctoType.FlexEnum, values: [:new, :ongoing, :ongoing_upcoming, :upcoming])
    field(:service_effect, :string)
    field(:severity, :integer)
    field(:short_header, :string)
    field(:timeframe, :string)
    field(:updated_at, EctoType.EasternDatetime)
    field(:url, :string)
  end

  @doc false
  def from_resource!(resource, included) do
    MBTAV3API.Schema.from_resource!(__MODULE__, resource, included)
  end
end
