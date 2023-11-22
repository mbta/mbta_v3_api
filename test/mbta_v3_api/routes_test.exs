defmodule MBTAV3API.RoutesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias JsonApi.Item
  alias MBTAV3API.Routes

  @opts ["page[limit]": 1, sort: "long_name"]

  describe "all/1" do
    test "gets all routes" do
      response = %JsonApi{data: [%Item{}]}

      opts = Keyword.put(@opts, :get_json_fn, fn "/routes/", @opts -> response end)

      assert Routes.all(opts) == response
    end
  end

  describe "get/1" do
    test "gets the route by ID" do
      response = %JsonApi{data: [%Item{id: "80"}]}

      opts = Keyword.put(@opts, :get_json_fn, fn "/routes/80", @opts -> response end)

      assert Routes.get("80", opts) == response
    end
  end

  describe "by_type/1" do
    test "gets routes by type" do
      response = %JsonApi{data: [%Item{id: "Blue"}]}

      expected_opts = Keyword.put(@opts, :type, 1)
      opts = Keyword.put(@opts, :get_json_fn, fn "/routes/", ^expected_opts -> response end)

      assert Routes.by_type(1, opts) == response
    end
  end

  describe "by_stop/2" do
    test "gets routes by stop ID" do
      response = %JsonApi{data: [%Item{id: "CR-Haverhill"}]}

      expected_opts = Keyword.put(@opts, :stop, "place-ogmnl")
      opts = Keyword.put(@opts, :get_json_fn, fn "/routes/", ^expected_opts -> response end)

      assert Routes.by_stop("place-ogmnl", opts) == response
    end
  end

  describe "by_stop_and_direction/3" do
    test "gets routes by stop ID and direction ID" do
      response = %JsonApi{data: [%Item{id: "743"}]}

      expected_opts =
        @opts
        |> Keyword.put(:stop, "place-sstat")
        |> Keyword.put(:direction_id, 0)

      opts = Keyword.put(@opts, :get_json_fn, fn "/routes/", ^expected_opts -> response end)

      assert Routes.by_stop_and_direction("place-sstat", 0, opts) == response
    end
  end
end
