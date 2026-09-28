defmodule MBTAV3API.ServicesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias JsonApi.Item
  alias MBTAV3API.Services

  @opts ["page[limit]": 1, sort: "id"]

  describe "all/1" do
    test "gets all services (for a given filter)" do
      response = %JsonApi{data: [%Item{}]}

      opts = Keyword.put(@opts, :route, "Red")
      opts = Keyword.put(opts, :get_json_fn, fn "/services/", ^opts -> response end)

      assert Services.all(opts) == response
    end
  end

  describe "get/1" do
    test "gets the services by ID" do
      response = %JsonApi{data: [%Item{id: "canonical"}]}

      opts = Keyword.put(@opts, :get_json_fn, fn "/services/canonical", @opts -> response end)

      assert Services.get("canonical", opts) == response
    end
  end
end
