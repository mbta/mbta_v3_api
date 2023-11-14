defmodule MBTAV3API.ApplicationTest do
  use ExUnit.Case

  describe "start/2" do
    @tag :capture_log
    test "can start the application" do
      Application.stop(:mbta_v3_api)
      assert {:ok, _pid} = MBTAV3API.Application.start(:temporary, [])
    end
  end
end
