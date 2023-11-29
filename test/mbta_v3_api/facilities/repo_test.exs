defmodule Facilities.RepoTest do
  @moduledoc false
  use ExUnit.Case

  alias JsonApi.Item
  alias MBTAV3API.Facilities.Repo

  describe "get_for_stop/1" do
    test "get filities from the api" do
      response = %JsonApi{data: [%Item{}]}

      opts = [facilities_filter_by_fn: fn [{"stop", "test-id"}] -> response end]

      assert Repo.get_for_stop("test-id", opts) == response
    end
  end
end
