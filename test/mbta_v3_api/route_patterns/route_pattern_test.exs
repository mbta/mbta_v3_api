defmodule MBTAV3API.RoutePatterns.RoutePatternTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import MBTAV3API.Support.Factory

  alias MBTAV3API.RoutePatterns.RoutePattern
  alias MBTAV3API.Stops.Stop

  describe "new/1" do
    test "constructs a RoutePattern struct given a JsonAPI Item" do
      item = build(:route_pattern_data)

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

    test "optionally includes stops" do
      item = List.first(build(:raw_route_patterns_with_stops).data)

      assert %RoutePattern{
               id: "Red-3-0",
               direction_id: 0,
               name: "Alewife - Braintree",
               headsign: "Braintree",
               representative_trip_id: "canonical-Red-C1-0",
               route_id: "Red",
               service_id: "canonical",
               shape_id: "canonical-933_0009",
               sort_order: 100_100_000,
               stop_ids: stop_ids,
               stops: stops,
               typicality: 1
             } = RoutePattern.new(item)

      assert is_list(stop_ids)
      assert Enum.all?(stop_ids, &is_binary/1)

      assert is_list(stops)
      assert Enum.all?(stops, &match?(%Stop{}, &1))
    end
  end
end
