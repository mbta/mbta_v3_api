defmodule MBTAV3API.PredictionTest do
  use ExUnit.Case

  alias MBTAV3API.Prediction

  test "can get predictions" do
    import Ecto.Query
    predictions = MBTAV3API.all(from(p in Prediction, where: p.stop_id == "place-boyls"))

    assert length(predictions) > 0

    assert %Prediction{} = hd(predictions)
  end
end
