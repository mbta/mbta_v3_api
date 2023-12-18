defmodule MBTAV3API.StopsTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.Stops

  describe "all" do
    test "gets all stops" do
      response = %JsonApi{data: [%Item{}]}

      opts = [get_json_fn: fn "/stops/", [] -> response end]

      assert Stops.all(opts) == response
    end
  end

  describe "by_gtfs_id/1" do
    test "gets the parent station info" do
      params = [include: "parent_station,facilities"]
      response = %JsonApi{data: [%Item{id: "123"}]}

      opts = [
        get_json_fn: fn "/stops/123", ^params, [] -> response end
      ]

      assert Stops.by_gtfs_id("123", params, opts) == response
    end
  end
end
