defmodule MBTAV3API.RoutePatterns.RoutePatternTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import MBTAV3API.Support.Factory

  alias MBTAV3API.RoutePatterns.RoutePattern

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
  end
end
