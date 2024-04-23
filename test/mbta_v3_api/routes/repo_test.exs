defmodule MBTAV3API.Routes.RepoTest do
  use ExUnit.Case, async: false

  import MBTAV3API.Support.Factory
  import Mock

  alias JsonApi.Item
  alias MBTAV3API.Routes
  alias MBTAV3API.Routes.{Repo, Route, Shape}
  alias MBTAV3API.Shapes

  @item build(:route_data)

  describe "all/0" do
    test "returns a list of Routes" do
      with_mock(Routes, all: fn _opts -> %JsonApi{data: [@item]} end) do
        assert [%Route{} | _] = Repo.all()
      end
    end

    test "parses the data into Route structs" do
      with_mock(Routes, all: fn _opts -> %JsonApi{data: [@item]} end) do
        assert Repo.all() |> List.first() == %Route{
                 id: "Orange",
                 type: 1,
                 name: "Orange Line",
                 long_name: "Orange Line",
                 color: "ED8B00",
                 direction_names: %{0 => "Southbound", 1 => "Northbound"},
                 direction_destinations: %{0 => "Forest Hills", 1 => "Oak Grove"},
                 description: :rapid_transit,
                 fare_class: :rapid_transit_fare,
                 line_id: "line-Orange",
                 sort_order: 10_020
               }
      end
    end
  end

  describe "get/1" do
    test "returns a single route" do
      with_mock(Routes, get: fn "Orange", _opts -> %JsonApi{data: [@item]} end) do
        assert %Route{
                 id: "Orange",
                 name: "Orange Line",
                 type: 1
               } = Repo.get("Orange")
      end
    end

    test "should return a generated route for Massport Routes" do
      assert %Route{
               description: "Massport Generated Route",
               id: "Massport-TEST",
               long_name: "Massport-TEST",
               name: "Massport-TEST",
               type: "Massport-TEST",
               custom_route?: true,
               color: "000000"
             } = Repo.get("Massport-TEST")
    end

    test "returns nil for an unknown route" do
      with_mock(Routes, get: fn _id, _opts -> {:error, "not found"} end) do
        refute Repo.get("_unknown_route")
      end
    end
  end

  describe "by_type/1" do
    test "only returns routes of a given type" do
      with_mock(Routes, all: fn _opts -> %JsonApi{data: [@item]} end) do
        one = Repo.by_type(1)
        assert one |> Enum.all?(fn route -> route.type == 1 end)
        assert one != []
        assert one == Repo.by_type([1])
      end
    end
  end

  describe "by_stop/1" do
    test "returns stops from different lines" do
      route_b = %Item{@item | id: "Green-B"}
      route_19 = %Item{@item | id: "19"}

      with_mock(Routes,
        by_stop: fn "place-kencl", _opts -> %JsonApi{data: [route_b, route_19]} end
      ) do
        route_ids = Repo.by_stop("place-kencl") |> Enum.map(& &1.id)
        assert "Green-B" in route_ids
        assert "19" in route_ids
      end
    end

    test "can specify type as param" do
      with_mock(Routes,
        by_stop: fn "place-kencl", [include: "route_patterns", type: 3] ->
          %JsonApi{data: [@item]}
        end
      ) do
        assert [%Route{} | _] = Repo.by_stop("place-kencl", type: 3)
      end
    end

    test "returns empty list if no routes of that type serve that stop" do
      with_mock(Routes,
        by_stop: fn "place-bmmnl", [include: "route_patterns", type: 0] -> %JsonApi{data: []} end
      ) do
        assert [] = Repo.by_stop("place-bmmnl", type: 0)
      end
    end

    test "returns no routes on nonexistant station" do
      with_mock(Routes, by_stop: fn "thisstopdoesntexist", _opts -> %JsonApi{data: []} end) do
        assert [] = Repo.by_stop("thisstopdoesntexist")
      end
    end

    test "can include additional routes via stop connections" do
      with_mock MBTAV3API.Routes, [],
        by_stop: &mock_routes_by_stop/1,
        by_stop: &mock_routes_by_stop/2 do
        routes = Repo.by_stop("initial-stop-id")
        more_routes = Repo.by_stop("initial-stop-id", include: "stop.connecting_stops")
        assert ["initial-route-id"] = Enum.map(routes, & &1.id)

        assert ["connecting-route-id-1", "connecting-route-id-2", "initial-route-id"] =
                 Enum.map(more_routes, & &1.id)
      end
    end
  end

  describe "by_stop_and_direction/2" do
    test "fetching routes for the same stop, but different direction" do
      with_mock(Routes,
        by_stop_and_direction: fn
          "1994", 0, _opts -> %JsonApi{data: [@item]}
          "1994", 1, _opts -> %JsonApi{data: []}
        end
      ) do
        winship_union_outbound_routes = Repo.by_stop_and_direction("1994", 0)
        winship_union_inbound_routes = Repo.by_stop_and_direction("1994", 1)

        assert Enum.any?(winship_union_outbound_routes, &(&1.id == "Orange"))
        refute Enum.any?(winship_union_inbound_routes, &(&1.id == "Orange"))
      end
    end
  end

  describe "handle_response/1" do
    test "parses routes" do
      response = %JsonApi{
        data: [
          %Item{
            attributes: %{
              "description" => "Local Bus",
              "direction_names" => ["Outbound", "Inbound"],
              "direction_destinations" => ["Start", "End"],
              "long_name" => "",
              "short_name" => "16",
              "sort_order" => 1600,
              "type" => 3
            },
            id: "16",
            relationships: %{},
            type: "route"
          },
          %Item{
            attributes: %{
              "description" => "Local Bus",
              "direction_names" => ["Outbound", "Inbound"],
              "direction_destinations" => ["Start", "End"],
              "long_name" => "",
              "short_name" => "36",
              "sort_order" => 3600,
              "type" => 3
            },
            id: "36",
            relationships: %{},
            type: "route"
          }
        ],
        links: %{}
      }

      assert {:ok, [%Route{id: "16"}, %Route{id: "36"}]} = Repo.handle_response(response)
    end

    test "removes hidden routes" do
      response = %JsonApi{
        data: [
          %Item{
            attributes: %{
              "description" => "Local Bus",
              "direction_names" => ["Outbound", "Inbound"],
              "direction_destinations" => ["Start", "End"],
              "long_name" => "",
              "short_name" => "36",
              "sort_order" => 3600,
              "type" => 3
            },
            id: "36",
            relationships: %{},
            type: "route"
          },
          %Item{
            attributes: %{
              "description" => "Limited Service",
              "direction_names" => ["Outbound", "Inbound"],
              "direction_destinations" => ["Start", "End"],
              "long_name" => "",
              "short_name" => "9701",
              "sort_order" => 970_100,
              "type" => 3
            },
            id: "9701",
            relationships: %{},
            type: "route"
          }
        ],
        links: %{}
      }

      assert {:ok, [%Route{id: "36"}]} = Repo.handle_response(response)
    end

    test "passes errors through" do
      error = {:error, %HTTPoison.Error{id: nil, reason: :timeout}}
      assert Repo.handle_response(error) == error
    end
  end

  describe "get_shapes/2" do
    test "Get valid response for bus route" do
      shape = build(:shape_data)

      with_mock(Shapes, all: fn [route: "Red", direction_id: 1] -> %JsonApi{data: [shape]} end) do
        assert [%Shape{id: "canonical-933_0009", stop_ids: [_ | _]}] =
                 Repo.get_shapes("Red", direction_id: 1)
      end
    end
  end

  describe "green_line" do
    test "returns a virtual route for the entire Green Line" do
      green_line = Repo.green_line()
      assert green_line.id == "Green"
      assert green_line.name == "Green Line"
    end
  end

  defp mock_routes_by_stop("connecting-stop-id") do
    %JsonApi{
      data: [
        %Item{
          id: "connecting-route-id-1",
          attributes: %{
            "direction_names" => ["Outbound", "Inbound"],
            "direction_destinations" => ["Start", "End"],
            "long_name" => "Connecting route at this stop"
          }
        },
        %Item{
          id: "connecting-route-id-2",
          attributes: %{
            "direction_names" => ["Outbound", "Inbound"],
            "direction_destinations" => ["Start", "End"],
            "long_name" => "Another connecting route at this stop"
          }
        }
      ]
    }
  end

  defp mock_routes_by_stop("initial-stop-id", include: "stop.connecting_stops") do
    %JsonApi{
      data: [
        %Item{
          id: "initial-route-id",
          attributes: %{
            "direction_names" => ["Outbound", "Inbound"],
            "direction_destinations" => ["Start", "End"],
            "long_name" => "Route with stops and connections"
          },
          relationships: %{
            "stop" => [
              %Item{
                id: "initial-stop-id",
                relationships: %{
                  "connecting_stops" => [%Item{id: "connecting-stop-id"}]
                }
              }
            ]
          }
        }
      ]
    }
  end

  defp mock_routes_by_stop("initial-stop-id", _opts) do
    %JsonApi{
      data: [
        %Item{
          id: "initial-route-id",
          attributes: %{
            "direction_names" => ["Outbound", "Inbound"],
            "direction_destinations" => ["Start", "End"],
            "long_name" => "Route with stops and connections"
          },
          relationships: %{}
        }
      ]
    }
  end
end
