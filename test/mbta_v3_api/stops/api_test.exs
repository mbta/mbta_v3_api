defmodule Stops.ApiTest do
  use ExUnit.Case

  import MBTAV3API.Support.Factory

  alias MBTAV3API.Stops.{Api, Stop}
  alias MBTAV3API.Stops.Stop.{ClosedStopInfo, ParkingLot}

  describe "by_gtfs_id/1" do
    test "uses the gtfs ID to find a stop" do
      stop_id = "place-NHRML-0127"
      response = %JsonApi{data: [build(:stop_data, id: stop_id)]}

      opts = [stops_by_gtfs_id_fn: fn ^stop_id, _params -> response end]

      assert {:ok, %Stop{} = stop} = Api.by_gtfs_id(stop_id, opts)

      assert stop.id == "place-NHRML-0127"
      assert stop.name == "Anderson/Woburn"
      assert stop.station?
      assert stop.accessibility != []
      assert stop.parking_lots != []

      for parking_lot <- stop.parking_lots do
        assert %ParkingLot{} = parking_lot
        assert parking_lot.capacity.total != nil
        manager = parking_lot.manager
        assert manager.name in ["Massport", "LAZ Parking"]
      end
    end

    test "parses parent_id and child_ids" do
      parent_stop_id = "place-NHRML-0127"

      opts = [
        stops_by_gtfs_id_fn: fn ^parent_stop_id, _params ->
          %JsonApi{data: [build(:stop_data, id: parent_stop_id)]}
        end
      ]

      assert {:ok, %Stop{} = parent} = Api.by_gtfs_id(parent_stop_id, opts)

      assert parent.parent_id == nil
      assert parent.is_child? == false
      assert parent.name == "Anderson/Woburn"
      assert parent.type == :station
      assert parent.platform_name == nil
      assert parent.platform_code == nil
      assert parent.description == nil

      assert Enum.member?(parent.child_ids, "NHRML-0127-02")

      child_stop_id = "NHRML-0127-02"

      child_opts = [
        stops_by_gtfs_id_fn: fn ^child_stop_id, _params ->
          %JsonApi{data: [build(:child_stop_data, id: child_stop_id)]}
        end
      ]

      assert {:ok, %Stop{} = child} = Api.by_gtfs_id(child_stop_id, child_opts)

      assert child.type == :stop
      assert child.parent_id == parent_stop_id
      assert child.child_ids == []
      assert child.is_child? == true
    end

    test "parses fare facilities" do
      stop_id = "place-NHRML-0127"

      opts = [
        stops_by_gtfs_id_fn: fn ^stop_id, _params ->
          %JsonApi{data: [build(:stop_data, id: stop_id)]}
        end
      ]

      assert {:ok, %Stop{} = station} = Api.by_gtfs_id(stop_id, opts)

      assert station.fare_facilities == MapSet.new([:fare_vending_machine])
      assert station.has_fare_machine?
    end

    test "can use the GTFS accessibility data" do
      stop_id = "place-NHRML-0127"

      opts = [
        stops_by_gtfs_id_fn: fn ^stop_id, _params ->
          %JsonApi{data: [build(:stop_data, id: stop_id)]}
        end
      ]

      assert {:ok, %Stop{} = stop} = Api.by_gtfs_id(stop_id, opts)
      assert ["accessible" | _] = stop.accessibility
    end

    test "returns nil if stop is not found" do
      opts = [stops_by_gtfs_id_fn: fn _, _ -> {:error, [%JsonApi.Error{code: "not_found"}]} end]

      assert Api.by_gtfs_id("unknown", opts) == {:ok, nil}
    end

    test "returns a stop even if the stop is not a station" do
      stop_id = "NHRML-0127-02"

      opts = [
        stops_by_gtfs_id_fn: fn ^stop_id, _params ->
          %JsonApi{data: [build(:child_stop_data, id: stop_id)]}
        end
      ]

      assert {:ok, %Stop{} = stop} = Api.by_gtfs_id(stop_id, opts)

      assert stop.id == stop_id
      refute stop.station?
    end

    test "returns an error if the API returns an error" do
      opts = [stops_by_gtfs_id_fn: fn _, _ -> {:error, "Error"} end]

      assert {:error, _} = Api.by_gtfs_id("error stop", opts)
    end
  end

  describe "all/0" do
    test "returns error if API returns error" do
      opts = [stops_all_fn: fn _ -> {:error, "Error"} end]

      assert {:error, _} = Api.all(opts)
    end
  end

  describe "by_route/1" do
    test "returns an error tuple if the V3 API returns an error" do
      opts = [stops_all_fn: fn _ -> {:error, "Error"} end]

      assert {:error, _} = Api.by_route({"1", 0, opts})
    end
  end

  describe "pretty_payment/1" do
    test "falls back to empty string" do
      assert Api.pretty_payment("invalid") == ""
    end
  end

  describe "by_trip/1" do
    test "returns an empty list if the V3 API returns an error" do
      opts = [trips_by_id_fn: fn _, _ -> {:error, "Error"} end]

      assert Api.by_trip("1", opts) == []
    end
  end
end
