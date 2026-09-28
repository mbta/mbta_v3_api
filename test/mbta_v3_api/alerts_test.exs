defmodule MBTAV3API.AlertsTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.Alerts

  describe "all/1" do
    test "gets all alerts" do
      response = %JsonApi{data: [%Item{}]}

      opts = [get_json_fn: fn "/alerts/", [] -> response end]

      assert Alerts.all(opts) == response
    end
  end
end
