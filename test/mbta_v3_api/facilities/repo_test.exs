defmodule Facilities.RepoTest do
  @moduledoc false
  use ExUnit.Case
  import MBTAV3API.Support.Factory
  import Mock

  alias JsonApi.Item
  alias MBTAV3API.Facilities
  alias MBTAV3API.Facilities.Facility
  alias MBTAV3API.Facilities.Repo

  @item build(:facility_data)

  @expected_response %Facility{
    id: "349",
    type: "ESCALATOR",
    short_name: "Platform to Russell Field",
    long_name: "Alewife Escalator 349 (Platform to Russell Field)",
    stop: %MBTAV3API.Stops.Stop{
      id: "place-alfcl",
      type: "stop"
    },
    latitude: 42.395428,
    longitude: -71.142483,
    properties: [
      %{name: "direction", value: "up"},
      %{name: "excludes-stop", value: 141},
      %{name: "excludes-stop", value: 9_070_061},
      %{name: "excludes-stop", value: "door-alfcl-alewife"},
      %{name: "excludes-stop", value: "door-alfcl-busway"},
      %{name: "excludes-stop", value: "door-alfcl-cambridgepark"},
      %{name: "excludes-stop", value: "door-alfcl-pathbusway"},
      %{name: "excludes-stop", value: "door-alfcl-steel"}
    ]
  }

  describe "get_for_stop/1" do
    test "get facilities from the api" do
      response = %JsonApi{data: [%Item{}]}

      opts = [facilities_filter_by_fn: fn [{"stop", "test-id"}] -> response end]

      assert Repo.get_for_stop("test-id", opts) == response
    end
  end

  describe "get/1" do
    test "get a parsed facility from the api" do
      with_mock Facilities, get: fn _id, _opts -> %JsonApi{data: [@item]} end do
        assert @expected_response = Repo.get("349", [])
      end
    end
  end
end
