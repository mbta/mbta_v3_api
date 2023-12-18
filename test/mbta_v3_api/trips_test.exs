defmodule MBTAV3API.TripsTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.Trips

  describe "by_id" do
    test "gets a trip by its ID" do
      response = %JsonApi{data: [%Item{id: "123"}]}

      opts = [get_json_fn: fn "/trips/123", [] -> response end]

      assert Trips.by_id("123", opts) == response
    end
  end

  describe "by_route" do
    test "gets trips on the requested route" do
      route_id = "39"
      response = %JsonApi{data: [%Item{id: route_id}]}

      opts = [get_json_fn: fn "/trips/", [route: ^route_id] -> response end]

      assert Trips.by_route(route_id, opts) == response
    end
  end
end
