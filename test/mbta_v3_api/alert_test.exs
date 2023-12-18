defmodule MBTAV3API.AlertTest do
  use ExUnit.Case

  alias MBTAV3API.Alert

  test "fetches all" do
    alerts = MBTAV3API.all(Alert)

    assert length(alerts) > 10
  end

  test "fetches one" do
    alert = MBTAV3API.get!(Alert, "513737")

    assert %Alert{
             id: "513737",
             active_periods: [active_period],
             cause: :unknown_cause,
             effect: :service_change,
             informed_entities: informed_entities,
             lifecycle: :ongoing,
             severity: 10
           } = alert

    assert ~N[2023-08-26 04:30:00] = active_period.start |> DateTime.to_naive()
    assert ~N[2023-12-23 02:30:00] = active_period.end |> DateTime.to_naive()

    assert ["WML-0252-01", "WML-0252-02", "place-WML-0252"] =
             informed_entities |> Enum.map(& &1.stop) |> Enum.sort()
  end
end
