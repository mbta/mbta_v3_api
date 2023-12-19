defmodule MBTAV3API.CacheTest do
  use ExUnit.Case

  alias MBTAV3API.Stop

  test "fills recursively" do
    assert %Stop{child_stops: [%Stop{id: child_stop_id} | _]} =
             MBTAV3API.get!(Stop, "place-unsqu", include: [:child_stops])

    assert {:ok, %Stop{parent_station_id: "place-unsqu"}} =
             MBTAV3API.Cache.get(Stop, child_stop_id)
  end
end
