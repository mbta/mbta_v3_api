defmodule MBTAV3API.RoutePatterns.RepoTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import MBTAV3API.Support.Factory

  alias MBTAV3API.RoutePatterns.{Repo, RoutePattern}

  describe "get" do
    test "returns a single route pattern" do
      route_pattern_id = "111-5-0"
      response = %JsonApi{data: [build(:route_pattern_data)]}

      opts = [route_patterns_get_fn: fn ^route_pattern_id, [] -> response end]

      assert %RoutePattern{id: ^route_pattern_id} = Repo.get(route_pattern_id, opts)
    end

    test "returns nil for an unknown route pattern" do
      opts = [route_patterns_get_fn: fn "unknown_route_pattern_id", [] -> {:error, "unknown"} end]

      assert Repo.get("unknown_route_pattern_id", opts) == nil
    end
  end

  describe "by_route_id" do
    test "returns route patterns for a route" do
      route_id = "Red"
      response = %JsonApi{data: [build(:route_pattern_data)]}

      opts = [
        route_patterns_all_fn: fn [sort: "typicality,sort_order", route: ^route_id] ->
          response
        end
      ]

      assert [%RoutePattern{} | _] = Repo.by_route_id(route_id, opts)
    end

    test "returns route patterns for all Green line branches" do
      response = %JsonApi{data: [build(:route_pattern_data)]}

      opts = [
        route_patterns_all_fn: fn [
                                    sort: "typicality,sort_order",
                                    route: "Green-B,Green-C,Green-D,Green-E"
                                  ] ->
          response
        end
      ]

      assert [%RoutePattern{} | _] = Repo.by_route_id("Green", opts)
    end

    test "takes a direction_id param" do
      route_id = "Red"
      response = %JsonApi{data: [build(:route_pattern_data)]}

      opts = [direction_id: 1]

      opts =
        Keyword.put(opts, :route_patterns_all_fn, fn [
                                                       sort: "typicality,sort_order",
                                                       route: ^route_id,
                                                       direction_id: 1
                                                     ] ->
          response
        end)

      assert [%RoutePattern{} | _] = Repo.by_route_id(route_id, opts)
    end
  end

  describe "by_stop_id/1" do
    test "returns route patterns for a stop, with shape and stops" do
      stop_id = "place-sstat"
      response = %JsonApi{data: [build(:route_pattern_with_shapes_and_stops_data)]}

      opts = [
        route_patterns_all_fn: fn [
                                    include:
                                      "representative_trip.shape,representative_trip.stops",
                                    stop: ^stop_id
                                  ] ->
          response
        end
      ]

      assert [%RoutePattern{representative_trip_polyline: polyline, stop_ids: stop_ids} | _] =
               Repo.by_stop_id(stop_id, opts)

      assert stop_ids
      assert polyline
    end
  end

  describe "included_stops_by_route_id/2" do
    test "parses included stops out of route_patterns response" do
      route_id = "Red"

      response = build(:raw_route_patterns_with_stops)
      opts = [direction_id: 0]

      opts =
        Keyword.put(opts, :route_patterns_all_fn, fn [
                                                       sort: "typicality,sort_order",
                                                       include: "representative_trip.stops",
                                                       route: ^route_id,
                                                       direction_id: 0
                                                     ] ->
          response
        end)

      result = Repo.included_stops_by_route_id(route_id, opts)

      expected = [
        "70061",
        "70063",
        "70065",
        "70067",
        "70069",
        "70071",
        "70073",
        "70075",
        "70077",
        "70079",
        "70081",
        "70083",
        "70085",
        "70087",
        "70089",
        "70091",
        "70093",
        "70095",
        "70097",
        "70099",
        "70101",
        "70103",
        "70105"
      ]

      assert result |> Enum.map(& &1.id) |> Enum.sort() == expected
      assert result |> length == 23
    end
  end
end
