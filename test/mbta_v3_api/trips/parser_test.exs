defmodule MBTAV3API.Trips.ParserTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import MBTAV3API.Support.Factory

  alias MBTAV3API.Schedules.Trip
  alias MBTAV3API.Trips.Parser

  describe "parse/1" do
    test "parse converts a JsonApi.Item into a map" do
      api_item = build(:trip_data)

      assert %Trip{
               id: "59813584",
               name: "TEST NAME",
               headsign: "Back Bay",
               direction_id: 1,
               shape_id: "390145",
               route_pattern_id: "39-3-1",
               bikes_allowed?: true
             } = Parser.parse(api_item)
    end
  end
end
