defmodule MBTAV3API.ShapesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias JsonApi.Item
  alias MBTAV3API.Shapes

  describe "all/1" do
    test "gets all shapes" do
      response = %JsonApi{data: [%Item{}]}

      opts = [get_json_fn: fn "/shapes/", [] -> response end]

      assert Shapes.all(opts) == response
    end
  end

  describe "by_id/2" do
    test "get the shape by ID" do
      response = %JsonApi{data: [%Item{id: "42"}]}

      opts = [get_json_fn: fn "/shapes/42", [], [] -> response end]

      assert Shapes.by_id("42", opts) == response
    end
  end
end
