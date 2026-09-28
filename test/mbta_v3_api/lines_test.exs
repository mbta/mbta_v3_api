defmodule MBTAV3API.LinesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias JsonApi.Item
  alias MBTAV3API.Lines

  @opts ["page[limit]": 1]

  describe "all/1" do
    test "gets all lines" do
      response = %JsonApi{data: [%Item{}]}

      opts = Keyword.put(@opts, :get_json_fn, fn "/lines/", @opts -> response end)

      assert Lines.all(opts) == response
    end
  end

  describe "get/1" do
    test "gets the line by ID" do
      response = %JsonApi{data: [%Item{id: "line-89"}]}

      opts = Keyword.put(@opts, :get_json_fn, fn "/lines/89", @opts -> response end)

      assert Lines.get("89", opts) == response
    end
  end
end
