defmodule MBTAV3API.Support.Factory do
  @moduledoc """
  ExMachina factory definitions for generating test data.
  """

  use ExMachina

  alias JsonApi.Item

  def route_pattern_data_factory do
    %Item{
      id: "111-5-0",
      type: "route_pattern",
      attributes: %{
        "canonical" => false,
        "direction_id" => 0,
        "name" => "Haymarket Station - Woodlawn",
        "sort_order" => 511_100_000,
        "time_desc" => nil,
        "typicality" => 1
      },
      relationships: %{
        "representative_trip" => [
          %Item{
            id: "60311384",
            type: "trip"
          }
        ],
        "route" => [
          %Item{
            id: "111",
            type: "route"
          }
        ]
      }
    }
  end
end
