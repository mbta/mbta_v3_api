defmodule MBTAV3API.Stops.RepoTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import Mock

  alias MBTAV3API.Routes.Repo, as: RoutesRepo
  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Stops.{Repo, Stop}

  describe "get/1" do
    test "returns a stop" do
      stop_id = "place-pktrm"

      opts = [stops_by_gtfs_id_fn: fn ^stop_id -> {:ok, %Stop{id: stop_id}} end]

      assert %Stop{id: ^stop_id} = Repo.get(stop_id, opts)
    end

    test "returns nil if the stop doesn't exist" do
      stop_id = "unknown"

      opts = [stops_by_gtfs_id_fn: fn ^stop_id -> {:ok, nil} end]

      assert Repo.get(stop_id, opts) == nil
    end
  end

  describe "get!/1" do
    test "returns a stop" do
      stop_id = "place-pktrm"

      opts = [stops_by_gtfs_id_fn: fn ^stop_id -> {:ok, %Stop{id: stop_id}} end]

      assert %Stop{id: ^stop_id} = Repo.get!(stop_id, opts)
    end

    test "raises a Stops.NotFoundError if the stop isn't found" do
      assert_raise Stops.NotFoundError, fn ->
        stop_id = "unknown"

        opts = [stops_by_gtfs_id_fn: fn ^stop_id -> {:ok, nil} end]

        Repo.get!(stop_id, opts)
      end
    end
  end

  describe "get_parent/1" do
    test "returns the parent stop for a child stop" do
      parent_stop_id = "parent-stop"

      opts = [stops_by_gtfs_id_fn: fn ^parent_stop_id -> {:ok, %Stop{id: parent_stop_id}} end]

      child_stop = %Stop{id: "child-stop", parent_id: parent_stop_id}

      assert %Stop{id: ^parent_stop_id} = Repo.get_parent(child_stop, opts)
    end

    test "returns the same stop for a parent stop" do
      parent_stop = %Stop{id: "parent-stop", parent_id: nil}

      assert Repo.get_parent(parent_stop) == parent_stop
    end

    test "takes ids" do
      parent_stop_id = "parent-stop"
      child_stop_id = "child-stop"

      opts = [
        stops_by_gtfs_id_fn: fn stop_id ->
          case stop_id do
            ^parent_stop_id -> {:ok, %Stop{id: parent_stop_id, parent_id: nil}}
            ^child_stop_id -> {:ok, %Stop{id: child_stop_id, parent_id: parent_stop_id}}
            _ -> {:ok, nil}
          end
        end
      ]

      assert %Stop{id: ^parent_stop_id} = Repo.get_parent(child_stop_id, opts)
    end
  end

  describe "by_route/3" do
    test "returns a list of stops in order of their stop_sequence" do
      route_id = "route-id"
      direction_id = 1
      first_stop = %Stop{id: "stop-first"}
      last_stop = %Stop{id: "stop-last"}

      opts = [by_route_fn: fn {^route_id, ^direction_id, []} -> [first_stop, last_stop] end]

      response = Repo.by_route(route_id, direction_id, opts)

      refute response == []
      assert List.first(response) == first_stop
      assert List.last(response) == last_stop
      assert response == Enum.uniq(response)
    end

    test "can take additional fields" do
      route_id = "route-id"
      direction_id = 1

      response = [%Stop{id: "stop-id"}]

      opts = [date: ~U[2021-01-01 11:00:00Z]]

      opts = Keyword.put(opts, :by_route_fn, fn {^route_id, ^direction_id, ^opts} -> response end)

      assert Repo.by_route(route_id, direction_id, opts) == response
    end

    test "caches per-stop as well" do
      route_id = "Red"
      direction_id = 1
      stop_id = "place-brntn"

      get_opts = [stops_by_gtfs_id_fn: fn ^stop_id -> {:ok, %Stop{id: stop_id}} end]

      ConCache.delete(Repo, {:by_route, {route_id, direction_id, []}})
      ConCache.put(Repo, {:stop, stop_id}, {:ok, "to-be-overwritten"})
      assert Repo.get(stop_id, get_opts) == "to-be-overwritten"

      by_route_opts = [
        by_route_fn: fn {^route_id, ^direction_id, []} -> [%Stop{id: stop_id}] end
      ]

      Repo.by_route(route_id, direction_id, by_route_opts)

      assert %Stop{id: ^stop_id} = Repo.get("place-brntn", get_opts)
    end
  end

  describe "by_route_type/2" do
    test "returns parent stops filtered by route type" do
      route_type = 2
      stop_id = "stop-id"
      stop = %Stop{id: stop_id, parent_id: nil}
      child_stop_1_id = "child-id-1"
      child_stop_1 = %Stop{id: child_stop_1_id, parent_id: stop_id}
      child_stop_2_id = "child-id-2"
      child_stop_2 = %Stop{id: child_stop_2_id, parent_id: stop_id}

      opts = [
        by_route_type_fn: fn {^route_type, []} -> [child_stop_1, child_stop_2] end,
        all_stops_fn: fn [filter: "stop-id"] -> [stop] end
      ]

      response = Repo.by_route_type(route_type, opts)

      assert Enum.find(response, &(&1.id == stop_id))

      # doesn't duplicate stops
      assert Enum.uniq(response) == response
    end
  end

  describe "child_stops_by_route_type/2" do
    test "returns stops filtered by route type" do
      route_type = 2
      stop_id = "stop-id"
      child_stop_1_id = "child-id-1"
      child_stop_1 = %Stop{id: child_stop_1_id, parent_id: stop_id}
      child_stop_2_id = "child-id-2"
      child_stop_2 = %Stop{id: child_stop_2_id, parent_id: stop_id}

      opts = [by_route_type_fn: fn {^route_type, []} -> [child_stop_1, child_stop_2] end]

      response = Repo.child_stops_by_route_type(route_type, opts)

      assert Enum.map(response, & &1.id) == [child_stop_1_id, child_stop_2_id]

      # doesn't duplicate stops
      assert Enum.uniq(response) == response
    end
  end

  describe "by_trip/2" do
    test "can return stops from a trip" do
      trip_id = "trip-id"

      opts = [by_trip_fn: fn ^trip_id -> [%Stop{id: "stop-id"}] end]

      assert [%Stop{} | _] = Repo.by_trip(trip_id, opts)
    end

    test "returns empty list if no trip matches" do
      trip_id = "unknown"

      opts = [by_trip_fn: fn ^trip_id -> [] end]

      assert Repo.by_trip(trip_id, opts) == []
    end
  end

  describe "stop_features/1" do
    @braintree %Stop{id: "place-brntn"}
    @braintree_routes [
      %Route{id: "Red", type: 1},
      %Route{id: "CR-Greenbush", type: 2},
      %Route{id: "210", type: 3}
    ]

    test "returns stop features for a given stop" do
      with_mock(RoutesRepo, by_stop: fn "place-brntn" -> @braintree_routes end) do
        features = Repo.stop_features(@braintree)
        assert :commuter_rail in features
        assert :red_line in features
        assert :bus in features
      end
    end

    test "returns stop features in correct order" do
      with_mock(RoutesRepo, by_stop: fn "place-brntn" -> @braintree_routes end) do
        assert Repo.stop_features(@braintree) == [:red_line, :bus, :commuter_rail]
      end
    end

    test "accessibility added if relevant" do
      with_mock(RoutesRepo, by_stop: fn "place-brntn" -> @braintree_routes end) do
        features = Repo.stop_features(%{@braintree | accessibility: ["accessible"]})
        assert features == [:red_line, :bus, :commuter_rail, :access]
      end
    end

    test "adds parking features if relevant" do
      with_mock(RoutesRepo, by_stop: fn "place-brntn" -> @braintree_routes end) do
        stop = %{@braintree | parking_lots: [%Stop.ParkingLot{}]}
        assert :parking_lot in Repo.stop_features(stop)
      end
    end

    test "excluded features are not returned" do
      with_mock(RoutesRepo, by_stop: fn "place-brntn" -> @braintree_routes end) do
        assert Repo.stop_features(@braintree, exclude: [:red_line]) == [:bus, :commuter_rail]
        assert Repo.stop_features(@braintree, exclude: [:red_line, :commuter_rail]) == [:bus]
      end
    end

    test "includes specific green_line branches if specified" do
      park = %Stop{id: "place-pktrm"}

      park_routes = [
        %Route{id: "Red", type: 1},
        %Route{id: "Green-B", type: 1},
        %Route{id: "Green-C", type: 1},
        %Route{id: "Green-D", type: 1},
        %Route{id: "Green-E", type: 1}
      ]

      with_mock(RoutesRepo, by_stop: fn "place-pktrm" -> park_routes end) do
        # when green line isn't expanded, keep it in GTFS order
        features = Repo.stop_features(park)
        assert features == [:red_line, :green_line_b, :green_line_c, :green_line_d, :green_line_e]
        # when green line is expanded, put the branches first
        features = Repo.stop_features(park, expand_branches?: true)
        assert features == [:"Green-B", :"Green-C", :"Green-D", :"Green-E", :red_line]
      end
    end
  end
end
