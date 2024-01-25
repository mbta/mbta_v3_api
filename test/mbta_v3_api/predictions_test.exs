defmodule MBTAV3API.PredictionsTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.Predictions

  describe "all" do
    test "gets all predictions" do
      response = %JsonApi{data: [%Item{}]}

      opts = [get_json_fn: fn "/predictions/", [] -> response end]

      assert Predictions.all([], opts) == response
    end
  end
end
