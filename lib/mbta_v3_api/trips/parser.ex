defmodule MBTAV3API.Trips.Parser do
  @moduledoc """
  Parse API data into Trip structs.
  """

  alias JsonApi.Item
  alias MBTAV3API.Schedules.Trip

  @spec parse(Item.t()) :: Trip.t()
  def parse(%Item{id: id, attributes: attributes, relationships: relationships}) do
    %Trip{
      id: id,
      name: attributes["name"],
      headsign: attributes["headsign"],
      direction_id: attributes["direction_id"],
      shape_id: parse_shape_id(relationships),
      route_pattern_id: parse_route_pattern_id(relationships),
      bikes_allowed?: attributes["bikes_allowed"] == 1
    }
  end

  defp parse_shape_id(%{"shape" => [head | _] = _lines}), do: head.id
  defp parse_shape_id(_), do: nil

  defp parse_route_pattern_id(%{"route_pattern" => [head | _] = _lines}), do: head.id
  defp parse_route_pattern_id(_), do: nil
end
