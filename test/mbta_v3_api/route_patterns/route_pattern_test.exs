defmodule MBTAV3API.RoutePatterns.RoutePatternTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias JsonApi.Item
  alias MBTAV3API.RoutePatterns.RoutePattern

  describe "new/1" do
    test "constructs a RoutePattern struct given a JsonAPI Item" do
      item = %Item{
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

      expected_result = %RoutePattern{
        id: "111-5-0",
        direction_id: 0,
        name: "Haymarket Station - Woodlawn",
        representative_trip_id: "60311384",
        route_id: "111",
        typicality: 1,
        sort_order: 511_100_000
      }

      assert RoutePattern.new(item) == expected_result
    end
  end
end
