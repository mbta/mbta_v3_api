defmodule MBTAV3APITest do
  use ExUnit.Case
  doctest MBTAV3API

  # TODO magic
  @tag timeout: :infinity
  test "stream works" do
    import Ecto.Query

    data =
      MBTAV3API.stream(from(p in MBTAV3API.Prediction, where: p.stop_id == "place-north"))
      |> Stream.filter(fn {type, _data} -> type in [:reset, :update] end)
      |> Enum.take(2)

    assert [{:reset, initial_data}, {:update, new_data}] = data

    assert [%MBTAV3API.Prediction{} | _] = initial_data
    assert %MBTAV3API.Prediction{} = new_data
  end
end
