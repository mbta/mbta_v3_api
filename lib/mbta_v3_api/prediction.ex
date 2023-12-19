defmodule MBTAV3API.Prediction do
  use MBTAV3API.Schema

  alias MBTAV3API.EctoType

  embedded_schema do
    field(:arrival_time, EctoType.EasternDatetime)
    field(:departure_time, EctoType.EasternDatetime)
    field(:direction_id, :integer)

    field(:schedule_relationship, EctoType.FlexEnum,
      values: [:added, :cancelled, :no_data, :skipped, :unscheduled]
    )

    field(:status, :string)
    field(:stop_sequence, :integer)

    belongs_to(:stop, MBTAV3API.Stop)
  end
end
