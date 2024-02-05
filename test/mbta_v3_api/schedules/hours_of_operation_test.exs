defmodule MBTAV3API.Schedules.HoursOfOperationTest do
  @moduledoc false
  use ExUnit.Case

  import Mock

  alias JsonApi.Item
  alias MBTAV3API.Schedules.{Departures, HoursOfOperation}
  alias MBTAV3API.Stops.Repo, as: StopsRepo
  alias MBTAV3API.Stops.Stop

  describe "hours_of_operation/2" do
    # test "returns basic hours for a route" do
    #   # does not validate the actual hours, that's in other tests
    #   actual = HoursOfOperation.hours_of_operation("47", :desc)
    #   assert %HoursOfOperation{} = actual
    #   assert {week_0, week_1} = actual.week
    #   assert {saturday_0, saturday_1} = actual.saturday
    #   assert {sunday_0, sunday_1} = actual.sunday
    #   assert %Departures{} = week_0
    #   assert %Departures{} = week_1
    #   assert %Departures{} = saturday_0
    #   assert %Departures{} = saturday_1
    #   assert %Departures{} = sunday_0
    #   assert %Departures{} = sunday_1
    # end

    # test "returns hours for a rapid_transit route" do
    #   # does not validate the actual hours, that's in other tests
    #   actual = HoursOfOperation.hours_of_operation("47", :rapid_transit)
    #   assert %HoursOfOperation{} = actual
    #   assert {week_0, week_1} = actual.week
    #   assert {saturday_0, saturday_1} = actual.saturday
    #   assert {sunday_0, sunday_1} = actual.sunday
    #   assert %{} = actual.special_service
    #   assert [%Departures{} | _rest] = week_0
    #   assert [%Departures{} | _rest] = week_1
    #   assert [%Departures{} | _rest] = saturday_0
    #   assert [%Departures{} | _rest] = saturday_1
    #   assert [%Departures{} | _rest] = sunday_0
    #   assert [%Departures{} | _rest] = sunday_1
    # end

    # test "can take a list of route IDs" do
    #   empty = %HoursOfOperation{}
    #   single_route = HoursOfOperation.hours_of_operation(["50"], :desc)

    #   assert %HoursOfOperation{} =
    #            multiple_routes = HoursOfOperation.hours_of_operation(["47", "50"], :desc)

    #   refute multiple_routes == empty
    #   refute multiple_routes == single_route
    # end
  end

  describe "api_params/4" do
    test "for a given date, returns a query for each relevant day of the week and direction_id" do
      date = ~D[2017-12-01]
      route_id = "route_id"
      [week_date, saturday_date, sunday_date] = HoursOfOperation.week_dates(date, [])
      actual = HoursOfOperation.api_params([route_id], date, :desc, [])

      assert [
               week_query,
               week_query_1,
               saturday_query,
               saturday_query_1,
               sunday_query,
               sunday_query_1
             ] = actual

      assert [
               {:route, ^route_id},
               {:date, ^week_date},
               {:direction_id, 0},
               {:stop_sequence, "first,last"} | _
             ] = week_query

      assert week_query_1[:route] == route_id
      assert week_query_1[:direction_id] == 1
      assert week_query_1[:date] == week_date
      assert saturday_query[:route] == route_id
      assert saturday_query[:date] == saturday_date
      assert saturday_query_1[:route] == route_id
      assert saturday_query_1[:date] == saturday_date
      assert sunday_query[:route] == route_id
      assert sunday_query[:date] == sunday_date
      assert sunday_query_1[:route] == route_id
      assert sunday_query_1[:date] == sunday_date
    end

    test "for rapid transit and a given date, returns a query for each relevant day of the week and direction_id" do
      date = ~D[2017-12-01]
      route_id = "route_id"
      [week_date, saturday_date, sunday_date] = HoursOfOperation.week_dates(date, [])
      actual = HoursOfOperation.api_params([route_id], date, :rapid_transit, [])

      [
        week_query,
        week_query_1,
        saturday_query,
        saturday_query_1,
        sunday_query,
        sunday_query_1
      ] = actual

      assert [
               {:route, ^route_id},
               {:date, ^week_date},
               {:direction_id, 0},
               {:"fields[schedule]", "departure_time,arrival_time"},
               {:include, "trip"},
               {:"fields[trip]", "headsign"} | _
             ] = week_query

      assert week_query_1[:route] == route_id
      assert week_query_1[:direction_id] == 1
      assert week_query_1[:date] == week_date
      assert saturday_query[:route] == route_id
      assert saturday_query[:date] == saturday_date
      assert saturday_query_1[:route] == route_id
      assert saturday_query_1[:date] == saturday_date
      assert sunday_query[:route] == route_id
      assert sunday_query[:date] == sunday_date
      assert sunday_query_1[:route] == route_id
      assert sunday_query_1[:date] == sunday_date
    end

    test "for rapid transit and a list of dates, returns a query for generated days, and days in the list" do
      date = ~D[2022-12-27]
      route_id = "route_id"
      special_service_dates = [~D[2022-12-27], ~D[2022-12-31]]

      [week_date, saturday_date, _sunday_date] =
        HoursOfOperation.week_dates(date, special_service_dates)

      actual =
        HoursOfOperation.api_params([route_id], date, :rapid_transit, special_service_dates)

      assert Kernel.length(actual) == 10

      [
        week_query_0,
        _week_query_1,
        _saturday_query_0,
        saturday_query_1,
        _sunday_query_0,
        _sunday_query_1,
        special_service_query_1_0,
        _special_service_query_1_1,
        _special_service_query_2_0,
        special_service_query_2_1
      ] = actual

      assert week_query_0[:route] == route_id
      assert week_query_0[:direction_id] == 0
      assert week_query_0[:date] == week_date
      assert saturday_query_1[:route] == route_id
      assert saturday_query_1[:date] == saturday_date
      assert saturday_query_1[:direction_id] == 1
      assert special_service_query_1_0[:date] == ~D[2022-12-27]
      assert special_service_query_1_0[:direction_id] == 0
      assert special_service_query_2_1[:date] == ~D[2022-12-31]
      assert special_service_query_2_1[:direction_id] == 1
    end
  end

  describe "parse_responses/3" do
    test "returns a timeout error if not all of the tasks complete within the timeout" do
      mock_params = [[], [], [], [], [], []]

      assert {:error, :timeout} =
               HoursOfOperation.parse_responses(
                 [
                   {:exit, :timeout},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}}
                 ],
                 :desc,
                 mock_params
               )
    end

    test "returns a timeout error if the API returns an error" do
      # {:ok, _} is from Task.async_stream
      # {:error, [%JsonApi.Error{}]} is from JsonApi
      error = {:error, [%JsonApi.Error{}]}
      mock_params = [[], [], [], [], [], []]

      assert {:error, :timeout} =
               HoursOfOperation.parse_responses(
                 [
                   {:ok, error},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}}
                 ],
                 :desc,
                 mock_params
               )
    end

    test "if they all complete, returns a %__MODULE__{} struct" do
      mock_params = [[], [], [], [], [], []]

      assert %HoursOfOperation{} =
               HoursOfOperation.parse_responses(
                 [
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}}
                 ],
                 :desc,
                 mock_params
               )
    end

    test "rapid transit if they all complete, returns a %__MODULE__{} struct" do
      mock_params = [[], [], [], [], [], []]

      assert %HoursOfOperation{} =
               HoursOfOperation.parse_responses(
                 [
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}},
                   {:ok, %JsonApi{}}
                 ],
                 :rapid_transit,
                 mock_params
               )
    end

    test "returns min/max times if present, otherwise :no_service" do
      {min_item, min_time} = build_schedule()
      {max_item, max_time} = build_schedule()
      {only_item, only_time} = build_schedule()
      sunday_out_of_service = {:error, [%JsonApi.Error{code: "no_service"}]}

      responses = [
        {:ok, %JsonApi{data: [max_item, min_item]}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{data: [only_item]}},
        {:ok, sunday_out_of_service},
        {:ok, %JsonApi{}}
      ]

      expected = %HoursOfOperation{
        week: {%Departures{first_departure: min_time, last_departure: max_time}, :no_service},
        saturday:
          {:no_service, %Departures{first_departure: only_time, last_departure: only_time}},
        sunday: {:no_service, :no_service},
        special_service: %{}
      }

      mock_params = [[], [], [], [], [], []]
      actual = HoursOfOperation.parse_responses(responses, :desc, mock_params)
      assert expected == actual
    end

    test "returns terminus status, and first and last departure times per stop for rapid transit if present, otherwise :no_service" do
      with_mock(StopsRepo, [:passthrough], get!: &test_stop_name(&1)) do
        {stop_1_d_1, stop_1_d_1_time} =
          build_schedule(%{stop_id: "1", departure_time: ~U[2022-01-01 10:45:00Z]})

        {stop_1_d_2, _stop_1_d_2_time} =
          build_schedule(%{stop_id: "1", departure_time: ~U[2022-01-01 10:55:00Z]})

        {stop_1_d_3, stop_1_d_3_time} =
          build_schedule(%{stop_id: "1", departure_time: ~U[2022-01-01 11:05:00Z]})

        {stop_2_d_1, stop_2_d_1_time} =
          build_schedule(%{stop_id: "2", departure_time: ~U[2022-01-01 10:45:00Z]})

        {stop_2_d_2, stop_2_d_2_time} =
          build_schedule(%{stop_id: "2", departure_time: ~U[2022-01-01 10:55:00Z]})

        sunday_out_of_service = {:error, [%JsonApi.Error{code: "no_service"}]}

        # 0 - week, saturday, sunday
        # 1 - week, saturday, sunday

        responses = [
          {:ok, %JsonApi{data: [stop_1_d_1, stop_1_d_2, stop_1_d_3, stop_2_d_1, stop_2_d_2]}},
          {:ok, %JsonApi{}},
          {:ok, %JsonApi{}},
          {:ok, %JsonApi{data: [stop_2_d_1]}},
          {:ok, sunday_out_of_service},
          {:ok, %JsonApi{}}
        ]

        expected = %HoursOfOperation{
          week:
            {[
               %Departures{
                 first_departure: stop_1_d_1_time,
                 last_departure: stop_1_d_3_time,
                 stop_id: "1",
                 is_terminus: true,
                 stop_name: "Test Stop"
               },
               %Departures{
                 first_departure: stop_2_d_1_time,
                 last_departure: stop_2_d_2_time,
                 stop_id: "2",
                 is_terminus: false,
                 stop_name: "Test Stop 2"
               }
             ], :no_service},
          saturday:
            {:no_service,
             [
               %Departures{
                 first_departure: stop_2_d_1_time,
                 last_departure: stop_2_d_1_time,
                 stop_id: "2",
                 is_terminus: false,
                 stop_name: "Test Stop 2"
               }
             ]},
          special_service: %{},
          sunday: {:no_service, :no_service}
        }

        mock_params = [[], [], [], [], [], []]
        actual = HoursOfOperation.parse_responses(responses, :rapid_transit, mock_params)
        assert expected == actual
      end
    end

    test "parses and returns rapid transit hours for any special service days" do
      with_mock(StopsRepo, [:passthrough], get!: &test_stop_name(&1)) do
        {stop_1_dep_1, stop_1_dep_1_time} =
          build_schedule(%{stop_id: "1", departure_time: ~U[2022-12-27 10:45:00Z]})

        {stop_1_dep_2, stop_1_dep_2_time} =
          build_schedule(%{stop_id: "1", departure_time: ~U[2022-12-27 23:45:00Z]})

        stop_2_date = ~D[2022-12-31]

        {stop_2_dep_1, stop_2_dep_1_time} =
          build_schedule(%{stop_id: "2", departure_time: ~U[2022-12-31 08:45:00Z]})

        {stop_2_dep_2, stop_2_dep_2_time} =
          build_schedule(%{stop_id: "2", departure_time: ~U[2022-12-31 22:45:00Z]})

        responses = [
          {:ok, %JsonApi{data: [stop_1_dep_1, stop_1_dep_2]}},
          {:ok, %JsonApi{}},
          {:ok, %JsonApi{}},
          {:ok, %JsonApi{}},
          {:ok, %JsonApi{}},
          {:ok, %JsonApi{}},
          {:ok, %JsonApi{data: [stop_2_dep_1, stop_2_dep_2]}},
          {:ok, %JsonApi{}}
        ]

        expected = %HoursOfOperation{
          week:
            {[
               %Departures{
                 first_departure: stop_1_dep_1_time,
                 last_departure: stop_1_dep_2_time,
                 stop_id: "1",
                 is_terminus: true,
                 stop_name: "Test Stop"
               }
             ], :no_service},
          saturday: {:no_service, :no_service},
          special_service: %{
            "2022-12-31" =>
              {[
                 %Departures{
                   first_departure: stop_2_dep_1_time,
                   last_departure: stop_2_dep_2_time,
                   stop_id: "2",
                   is_terminus: false,
                   stop_name: "Test Stop 2"
                 }
               ], :no_service}
          },
          sunday: {:no_service, :no_service}
        }

        mock_params = [[], [], [], [], [], [], [date: stop_2_date], [date: stop_2_date]]
        actual = HoursOfOperation.parse_responses(responses, :rapid_transit, mock_params)
        assert expected == actual
      end
    end

    test "returns no service for special service days not in service" do
      stop_2_date = ~D[2022-12-31]

      responses = [
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}},
        {:ok, %JsonApi{}}
      ]

      expected = %HoursOfOperation{
        week: {:no_service, :no_service},
        saturday: {:no_service, :no_service},
        special_service: %{
          "2022-12-31" => {:no_service, :no_service}
        },
        sunday: {:no_service, :no_service}
      }

      mock_params = [[], [], [], [], [], [], [date: stop_2_date], [date: stop_2_date]]
      actual = HoursOfOperation.parse_responses(responses, :rapid_transit, mock_params)
      assert expected == actual
    end
  end

  describe "join_hours/2" do
    test "returns a single struct" do
      assert HoursOfOperation.join_hours([%HoursOfOperation{}], :desc) == %HoursOfOperation{}
    end

    test "combines multiple structs, taking the earlier/latest times" do
      lower = DateTime.utc_now()
      middle = DateTime.utc_now()
      higher = DateTime.utc_now()
      lower_middle = %Departures{first_departure: lower, last_departure: middle}
      middle_higher = %Departures{first_departure: middle, last_departure: higher}
      lower_higher = %Departures{first_departure: lower, last_departure: higher}

      expected = %HoursOfOperation{
        week: {lower_higher, lower_higher},
        saturday: {lower_higher, lower_higher},
        sunday: {lower_higher, lower_higher}
      }

      actual =
        HoursOfOperation.join_hours(
          [
            %HoursOfOperation{
              week: {:no_service, lower_middle},
              saturday: {middle_higher, :no_service},
              sunday: {lower_middle, lower_middle}
            },
            %HoursOfOperation{},
            %HoursOfOperation{
              week: {lower_higher, middle_higher},
              saturday: {lower_middle, lower_higher},
              sunday: {middle_higher, middle_higher}
            }
          ],
          :desc
        )

      assert expected == actual
    end
  end

  describe "week_dates/2" do
    test "for a given date, returns the next monday, saturday, and sunday" do
      # Thursday
      date = ~D[2017-10-26]

      assert HoursOfOperation.week_dates(date, []) == [
               # This day
               ~D[2017-10-26],
               # Upcoming Saturday
               ~D[2017-10-28],
               # Upcoming Sunday
               ~D[2017-10-29]
             ]
    end

    test "on a sunday, we use the saturday from next week" do
      date = ~D[2017-10-29]

      assert HoursOfOperation.week_dates(date, []) == [
               # Next Monday
               ~D[2017-10-30],
               # Next Saturday
               ~D[2017-11-04],
               date
             ]
    end

    test "always generates valid responses" do
      Enum.map(0..364, &Timex.shift(~D[2017-01-01], days: &1))
      |> Enum.each(fn test_date ->
        [weekday, saturday, sunday] = HoursOfOperation.week_dates(test_date, [])
        assert Date.day_of_week(weekday) in 1..5
        assert Date.day_of_week(saturday) == 6
        assert Date.day_of_week(sunday) == 7
      end)
    end

    test "should avoid today and sunday, using tomorrow and next sunday instead" do
      date = ~D[2022-12-27]

      assert HoursOfOperation.week_dates(date, [~D[2022-12-27], ~D[2023-01-01]]) == [
               ~D[2022-12-28],
               ~D[2022-12-31],
               ~D[2023-01-08]
             ]
    end
  end

  describe "Enumerable" do
    test "returns items in week/saturday/sunday order, ignoring no-service dates" do
      now = DateTime.utc_now()
      departure = %Departures{first_departure: now, last_departure: now}

      hours = %HoursOfOperation{
        week: {:no_service, departure},
        saturday: {:no_service, :no_service},
        sunday: {departure, :no_service}
      }

      assert Enum.count(hours) == 2
      assert Enum.into(hours, []) == [week: hours.week, sunday: hours.sunday]
    end
  end

  defp test_stop_name("1"), do: %Stop{name: "Test Stop"}
  defp test_stop_name("2"), do: %Stop{name: "Test Stop 2"}

  defp build_schedule(
         %{stop_id: stop_id, departure_time: departure_time} \\ %{
           stop_id: "1",
           departure_time: DateTime.utc_now()
         }
       ) do
    item = %Item{
      type: "schedule",
      attributes: %{
        "departure_time" => DateTime.to_iso8601(departure_time)
      },
      relationships: %{
        "trip" => [
          %{
            attributes: %{
              "headsign" => "Test Stop"
            }
          }
        ],
        "stop" => [
          %{
            id: stop_id
          }
        ]
      }
    }

    {item, departure_time}
  end
end
