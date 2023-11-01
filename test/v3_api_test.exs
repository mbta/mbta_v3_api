defmodule V3ApiTest do
  use ExUnit.Case
  doctest V3Api

  test "greets the world" do
    assert V3Api.hello() == :world
  end
end
