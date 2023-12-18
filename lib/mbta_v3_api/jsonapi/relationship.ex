defmodule MBTAV3API.JSONAPI.Relationship do
  alias MBTAV3API.JSONAPI.Included
  alias MBTAV3API.JSONAPI.Links
  alias MBTAV3API.JSONAPI.ResourceIdentifier

  @type t :: %__MODULE__{
          links: Links.t() | nil,
          data: ResourceIdentifier.t() | list(ResourceIdentifier.t()) | nil
        }

  defstruct [:links, :data]

  def parse!(data) when is_map(data) do
    unless data == %{"data" => nil} do
      %__MODULE__{
        links: Links.parse!(data["links"]),
        data: parse_data!(data["data"])
      }
    end
  end

  def id(nil), do: nil
  def id(%__MODULE__{data: %ResourceIdentifier{id: id}}), do: id

  @spec unpack(result, %{String.t() => t()}, atom(), Included.t()) :: result
        when result: Ecto.Schema.embedded_schema()
  def unpack(result_struct, relationships, field, included) do
    expected_cardinality = result_struct.__struct__.__schema__(:association, field).cardinality

    case relationships["#{field}"] do
      %__MODULE__{data: data} when is_list(data) and expected_cardinality == :many ->
        struct!(result_struct, %{field => data |> Enum.map(&Included.fetch!(included, &1))})

      %__MODULE__{data: %ResourceIdentifier{} = data} when expected_cardinality == :one ->
        struct!(result_struct, %{field => Included.fetch!(included, data)})

      %__MODULE__{data: nil} ->
        result_struct

      nil ->
        result_struct
    end
  end

  defp parse_data!(nil), do: nil

  defp parse_data!(data) when is_map(data) do
    ResourceIdentifier.parse!(data)
  end

  defp parse_data!(data) when is_list(data) do
    Enum.map(data, &parse_data!/1)
  end
end
