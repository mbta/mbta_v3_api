defmodule MBTAV3API.FacilityTest do
  use ExUnit.Case

  alias MBTAV3API.FacilityProperties
  alias MBTAV3API.Facility

  test "decodes including everything" do
    facility = MBTAV3API.get!(Facility, "park-north-garage", include: :stop)

    assert %Facility{
             id: "park-north-garage",
             latitude: 42.366083,
             long_name: "North Station Garage",
             longitude: -71.06214,
             properties: %FacilityProperties{
               attended: true,
               capacity: 1275,
               capacity_accessible: 38,
               car_sharing: [],
               contact: "ProPark",
               enclosed: true,
               excludes_stop: [],
               municipality: "Boston",
               operator: "ProPark",
               payment_form_accepted: [:cash, :credit_debit_card]
             },
             short_name: "Garage",
             stop: %MBTAV3API.Stop{},
             stop_id: "place-north",
             type: :parking_area
           } = facility
  end
end
