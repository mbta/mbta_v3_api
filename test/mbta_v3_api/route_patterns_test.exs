defmodule MBTAV3API.RoutePatternsTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.RoutePatterns

  @params ["page[limit]": 1, sort: "id"]

  describe "all/1" do
    test "gets all route patterns" do
      response = %JsonApi{data: [%Item{}]}

      opts = [get_json_fn: fn "/route_patterns/", @params -> response end]

      assert RoutePatterns.all(@params, opts) == response
    end
  end

  describe "get/1" do
    test "gets the route pattern by ID" do
      route_pattern_id = "111-5-0"
      response = %JsonApi{data: [%Item{id: route_pattern_id}]}

      expected_path = "/route_patterns/#{route_pattern_id}"

      opts = [get_json_fn: fn ^expected_path -> response end]

      assert RoutePatterns.get(route_pattern_id, opts) == response
    end
  end
end
