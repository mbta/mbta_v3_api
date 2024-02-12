defmodule MBTAV3API.TripsTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.Schedules.Trip
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

  describe "by_route_and_directions" do
    test "gets trips on this route in a single direction" do
      route_id = "39"
      direction_id = 0

      opts = [
        get_json_fn: fn "/trips/", [direction_id: ^direction_id, route: ^route_id] ->
          %JsonApi{
            data: [
              %Item{id: route_id, attributes: %{"direction_id" => 0}}
            ]
          }
        end
      ]

      expected_response = [
        %Trip{
          id: route_id,
          direction_id: direction_id
        }
      ]

      assert Trips.by_route_and_directions(route_id, [direction_id], opts) == expected_response
    end

    test "gets trips on this route in both directions" do
      route_id = "39"

      opts = [
        get_json_fn: fn "/trips/", [route: ^route_id] ->
          %JsonApi{
            data: [
              %Item{id: route_id, attributes: %{"direction_id" => 0}},
              %Item{id: route_id, attributes: %{"direction_id" => 1}}
            ]
          }
        end
      ]

      expected_response = [
        %Trip{
          id: route_id,
          direction_id: 0
        },
        %Trip{
          id: route_id,
          direction_id: 1
        }
      ]

      assert Trips.by_route_and_directions(route_id, [0, 1], opts) == expected_response
    end
  end
end
