defmodule V3Api.ApplicationTest do
  use ExUnit.Case

  describe "start/2" do
    @tag :capture_log
    test "can start the application" do
      Application.stop(:v3_api)
      assert {:ok, _pid} = V3Api.Application.start(:temporary, [])
    end
  end
end
