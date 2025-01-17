defmodule MBTAV3API.Lines.RepoTest do
  use ExUnit.Case, async: false

  import MBTAV3API.Support.Factory
  import Mock

  alias MBTAV3API.Lines
  alias MBTAV3API.Lines.{Repo, Line}

  @item build(:line_data)

  describe "all/0" do
    test "returns a list of Lines" do
      with_mock(Lines, all: fn _opts -> %JsonApi{data: [@item]} end) do
        assert [%Line{} | _] = Repo.all()
      end
    end
  end

  test "parses the data into Line structs" do
    with_mock(Lines, all: fn _opts -> %JsonApi{data: [@item]} end) do
      assert Repo.all() |> List.first() == %Line{
               id: "line-89",
               long_name: "Clarendon Hill or Davis - Sullivan",
               name: "89",
               sort_order: 50890,
               route_ids: ["89", "8993"]
             }
    end
  end

  describe "get/1" do
    test "returns a single line" do
      with_mock(Lines, get: fn "89", _opts -> %JsonApi{data: [@item]} end) do
        assert %Line{
                 id: "line-89",
                 name: "89"
               } = Repo.get("89")
      end
    end

    test "returns nil for an unknown line" do
      with_mock(Lines, get: fn _id, _opts -> {:error, "not found"} end) do
        refute Repo.get("_unknown_line")
      end
    end
  end
end
