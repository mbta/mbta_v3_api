defmodule MBTAV3API.Lines.Parser do
  @moduledoc "Functions for parsing generic JSON:API structs into Lines structs."

  alias JsonApi.Item
  alias MBTAV3API.Lines.Line

  @spec parse_line(Item.t()) :: Line.t()
  def parse_line(%Item{id: id, attributes: attributes, relationships: relationships}) do
    %Line{
      id: id,
      name: name(attributes),
      long_name: attributes["long_name"],
      sort_order: attributes["sort_order"],
      route_ids: parse_route_ids(relationships)
    }
  end

  defp parse_route_ids(%{"routes" => [_ | _] = routes}) do
    Enum.map(routes, & &1.id)
  end

  defp parse_route_ids(_), do: nil

  @spec name(map) :: String.t()
  def name(%{"long_name" => long_name, "short_name" => ""}), do: long_name
  def name(%{"short_name" => short_name}), do: short_name
end
