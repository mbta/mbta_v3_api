defmodule MBTAV3API.Services.RepoTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias JsonApi.Item
  alias MBTAV3API.Services.{Repo, Service}

  @item %Item{
    attributes: %{
      "added_dates" => [
        "2019-06-29",
        "2019-07-06",
        "2019-07-13"
      ],
      "end_date" => "2019-08-31",
      "schedule_type" => "Saturday",
      "schedule_typicality" => 6,
      "start_date" => "2019-06-29"
    },
    type: "service"
  }

  describe "by_id" do
    test "fetches service by ID" do
      response = %JsonApi{data: [@item]}

      opts = [services_get_fn: fn "canonical" -> response end]

      assert %Service{} = Repo.by_id("canonical", opts)
    end
  end

  describe "by_route_id" do
    test "fetches services for a route" do
      response = %JsonApi{data: [@item]}

      opts = [services_all_fn: fn [route: "Red"] -> response end]

      assert [%Service{} | _] = Repo.by_route_id("Red", [], opts)
    end

    test "fetches services for a list" do
      response = %JsonApi{data: [@item]}

      opts = [services_all_fn: fn [route: "Red"] -> response end]

      assert [%Service{} | _] = Repo.by_route_id(["Red"], [], opts)
    end

    test "fetches services for the green line" do
      response = %JsonApi{data: [@item]}

      params = []
      opts = [services_all_fn: fn [route: _] -> response end]

      assert Repo.by_route_id("Green", params, opts) ==
               Repo.by_route_id("Green-B,Green-C,Green-D,Green-E", params, opts)
    end
  end
end
