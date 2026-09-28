defmodule MBTAV3API.SchedulesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias JsonApi.Item
  alias MBTAV3API.Schedules

  describe "all" do
    test "gets all schedules" do
      response = %JsonApi{data: [%Item{}]}

      opts = [get_json_fn: fn "/schedules/", [] -> response end]

      assert Schedules.all([], opts) == response
    end
  end
end
