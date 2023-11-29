defmodule MBTAV3API.FacilitiesTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.Facilities

  describe "all" do
    test "gets all facilities" do
      response = %JsonApi{data: [%Item{}]}

      opts = [get_json_fn: fn "/facilities/", [], [] -> response end]

      assert Facilities.all([], opts) == response
    end
  end

  describe "filter_by/2" do
    test "gets filtered facilities" do
      response = %JsonApi{data: [%Item{id: "123"}]}

      opts = [
        get_json_fn: fn "/facilities/",
                        [{"filter[stop]", "place-alfcl"}, {"filter[type]", "ELEVATOR"}],
                        [] ->
          response
        end
      ]

      assert Facilities.filter_by(
               [
                 {"stop", "place-alfcl"},
                 {"type", "ELEVATOR"}
               ],
               opts
             ) == response
    end
  end
end
