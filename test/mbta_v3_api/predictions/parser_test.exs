defmodule MBTAV3API.Predictions.ParserTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Mock

  alias JsonApi.Item
  alias MBTAV3API.Predictions.Parser
  alias MBTAV3API.Routes.Repo, as: RoutesRepo
  alias MBTAV3API.Routes.Route

  describe "parse/1" do
    test "parses a %JsonApi.Item{} into a record" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        item = %Item{
          attributes: %{
            "track" => "5",
            "status" => "On Time",
            "direction_id" => 0,
            "departure_time" => "2016-09-15T15:40:00-04:00",
            "arrival_time" => "2016-01-01T00:00:00-04:00",
            "stop_sequence" => 5
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 5
                }
              },
              %Item{id: "wrong"}
            ],
            "stop" => [
              %Item{id: "place-pktrm", attributes: %{"name" => "Stop"}},
              %Item{id: "wrong"}
            ],
            "trip" => [
              %Item{
                id: "trip_id",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              },
              %Item{
                id: "wrong",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              }
            ],
            "vehicle" => [
              %Item{
                id: "vehicle_id"
              }
            ]
          }
        }

        expected = {
          nil,
          "trip_id",
          "place-pktrm",
          "route_id",
          0,
          Timex.to_datetime({{2016, 1, 1}, {0, 0, 0}}, "Etc/UTC-4"),
          Timex.to_datetime({{2016, 9, 15}, {15, 40, 0}}, "Etc/UTC-4"),
          Timex.to_datetime({{2016, 1, 1}, {0, 0, 0}}, "Etc/UTC-4"),
          5,
          nil,
          "5",
          "On Time",
          true,
          "vehicle_id"
        }

        assert Parser.parse(item) == expected
      end
    end

    test "uses arrival time if departure time isn't available" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        item = %Item{
          attributes: %{
            "track" => nil,
            "status" => "On Time",
            "direction_id" => 0,
            "departure_time" => nil,
            "arrival_time" => "2016-09-15T15:40:00+01:00"
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 5
                }
              },
              %Item{id: "wrong"}
            ],
            "stop" => [
              %Item{id: "place-pktrm", attributes: %{"name" => "Stop"}},
              %Item{id: "wrong"}
            ],
            "trip" => [
              %Item{
                id: "trip_id",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              },
              %Item{
                id: "wrong",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              }
            ],
            "vehicle" => [
              %Item{
                id: "vehicle_id"
              }
            ]
          }
        }

        parsed = Parser.parse(item)

        assert elem(parsed, 5) == Timex.to_datetime({{2016, 9, 15}, {15, 40, 0}}, "Etc/UTC+1")
        refute elem(parsed, 10)
      end
    end

    test "can parse a prediction with no times" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        item = %Item{
          attributes: %{
            "track" => "5",
            "status" => "On Time",
            "direction_id" => 0,
            "departure_time" => nil,
            "arrival_time" => nil
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 5
                }
              },
              %Item{id: "wrong"}
            ],
            "stop" => [
              %Item{id: "place-pktrm", attributes: %{"name" => "Stop"}},
              %Item{id: "wrong"}
            ],
            "trip" => [
              %Item{
                id: "trip_id",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              },
              %Item{
                id: "wrong",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              }
            ],
            "vehicle" => [
              %Item{
                id: "vehicle_id"
              }
            ]
          }
        }

        parsed = Parser.parse(item)

        assert elem(parsed, 7) == nil
        refute elem(parsed, 12)
      end
    end

    test "can parse a prediction where the track is part of the stop" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        item = %Item{
          attributes: %{
            "status" => "On Time",
            "direction_id" => 0,
            "departure_time" => "2018-06-15T12:00:00-04:00",
            "arrival_time" => nil
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 5
                }
              },
              %Item{id: "wrong"}
            ],
            "stop" => [%Item{id: "South Station-11", attributes: %{"platform_code" => "11"}}],
            "trip" => [
              %Item{
                id: "trip_id",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              },
              %Item{
                id: "wrong",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              }
            ],
            "vehicle" => [
              %Item{
                id: "vehicle_id"
              }
            ]
          }
        }

        parsed = Parser.parse(item)

        assert elem(parsed, 10) == "11"
      end
    end

    test "can parse possible schedule relationships" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        base_item = %Item{
          attributes: %{
            "track" => nil,
            "status" => "On Time",
            "direction_id" => 0,
            "departure_time" => "2016-09-15T15:40:00-04:00",
            "arrival_time" => "2016-01-01T00:00:00-04:00"
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 5
                }
              },
              %Item{id: "wrong"}
            ],
            "stop" => [
              %Item{id: "place-pktrm", attributes: %{"name" => "Stop"}},
              %Item{id: "wrong"}
            ],
            "trip" => [
              %Item{
                id: "trip_id",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              },
              %Item{
                id: "wrong",
                attributes: %{
                  "name" => "trip_name",
                  "direction_id" => "0",
                  "headsign" => "trip_headsign"
                }
              }
            ],
            "vehicle" => [
              %Item{
                id: "vehicle_id"
              }
            ]
          }
        }

        for {json, expected} <- [
              {nil, nil},
              {"unknown", nil},
              {"ADDED", :added},
              {"SKIPPED", :skipped},
              {"CANCELLED", :cancelled},
              {"UNSCHEDULED", :unscheduled},
              {"NO_DATA", :no_data}
            ] do
          # update the item to set the given JSON relationship
          item = %{
            base_item
            | attributes: Map.put(base_item.attributes, "schedule_relationship", json)
          }

          parsed = Parser.parse(item)
          assert elem(parsed, 9) == expected
        end
      end
    end

    test "can handle empty trip relationships" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        item = %Item{
          attributes: %{
            "track" => nil,
            "status" => "On Time",
            "direction_id" => 0,
            "departure_time" => "2016-09-15T15:40:00-04:00",
            "arrival_time" => "2016-01-01T00:00:00-04:00"
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 5
                }
              }
            ],
            "stop" => [%Item{id: "place-pktrm", attributes: %{"name" => "Stop"}}],
            "trip" => [],
            "vehicle" => [
              %Item{
                id: "vehicle_id"
              }
            ]
          }
        }

        parsed = Parser.parse(item)
        assert elem(parsed, 1) == nil
      end
    end

    test "can handle empty vehicle relationship" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        item = %Item{
          attributes: %{
            "track" => nil,
            "status" => "On Time",
            "direction_id" => 0,
            "departure_time" => "2016-09-15T15:40:00-04:00",
            "arrival_time" => "2016-01-01T00:00:00-04:00"
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 5
                }
              }
            ],
            "stop" => [%Item{id: "place-pktrm", attributes: %{"name" => "Stop"}}],
            "trip" => [],
            "vehicle" => []
          }
        }

        parsed = Parser.parse(item)
        assert elem(parsed, 13) == nil
      end
    end

    test "departing status is determined by prediction status if no time is given" do
      with_mock(RoutesRepo, get: fn _ -> %Route{id: "route_id", type: 0} end) do
        json_item = %Item{
          attributes: %{
            "track" => nil,
            "status" => "3 stops away",
            "direction_id" => 0,
            "departure_time" => nil,
            "arrival_time" => nil
          },
          relationships: %{
            "route" => [
              %Item{
                id: "route_id",
                attributes: %{
                  "long_name" => "Route",
                  "direction_names" => ["East", "West"],
                  "type" => 1
                }
              }
            ],
            "stop" => [%Item{id: "place-pktrm", attributes: %{"name" => "Stop"}}],
            "trip" => [],
            "vehicle" => [
              %Item{
                id: "vehicle_id"
              }
            ]
          }
        }

        parsed = Parser.parse(json_item)
        assert elem(parsed, 12)
      end
    end
  end
end
