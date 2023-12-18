defmodule MBTAV3API.StopTest do
  use ExUnit.Case

  alias MBTAV3API.Stop

  test "decodes including everything" do
    stop =
      MBTAV3API.get!(Stop, "place-boyls",
        include: [:child_stops, :connecting_stops, :facilities, :parent_station]
      )

    assert %Stop{
             child_stops: child_stops,
             connecting_stops: connecting_stops,
             facilities: facilities,
             parent_station_id: nil
           } = stop

    assert [
             %Stop{id: "70158", parent_station_id: "place-boyls", parent_station: nil},
             %Stop{id: "70159", parent_station_id: "place-boyls", parent_station: nil},
             %Stop{id: "door-boyls-inbound"},
             %Stop{id: "door-boyls-outbound"}
           ] = child_stops |> Enum.filter(&(&1.location_type != :generic_node))

    assert [%Stop{id: "8279", name: "Tremont St @ Boylston Station", vehicle_type: :bus}] =
             connecting_stops

    assert length(facilities) == 5
    assert Enum.all?(facilities, &(&1.type == :fare_vending_machine))
  end

  test "validates include" do
    assert_raise(RuntimeError, "Can't include invalid on MBTAV3API.Stop", fn ->
      MBTAV3API.get!(Stop, "place-boyls", include: :invalid)
    end)
  end
end
