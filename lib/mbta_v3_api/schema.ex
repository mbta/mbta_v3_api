defmodule MBTAV3API.Schema do
  alias MBTAV3API.JSONAPI
  alias MBTAV3API.JSONAPI.Relationship

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :string, []}
      @foreign_key_type :string
    end
  end

  def from_resource!(
        module,
        %JSONAPI.Resource{
          id: id,
          attributes: attributes,
          relationships: relationships
        },
        included
      ) do
    all_fields = module.__schema__(:fields)
    assoc_fields = module.__schema__(:associations)

    relationship_ids =
      relationships
      |> Enum.map(fn {name, rel} ->
        id_field_name = "#{name}_id"

        if Enum.any?(all_fields, &(id_field_name == Atom.to_string(&1))) do
          {id_field_name, Relationship.id(rel)}
        end
      end)
      |> Enum.reject(&is_nil/1)
      |> Map.new()

    changeset =
      struct!(module, id: id)
      |> changeset(Map.merge(attributes, relationship_ids))

    object = changeset |> Ecto.Changeset.apply_action!(changeset.action)

    assoc_fields
    |> Enum.reduce(object, fn assoc_field, object ->
      Relationship.unpack(object, relationships, assoc_field, included)
    end)
  end

  defp changeset(schema, params) do
    %module{} = schema
    all_fields = module.__schema__(:fields)
    embed_fields = module.__schema__(:embeds)
    assoc_fields = module.__schema__(:associations)

    changeset =
      Ecto.Changeset.cast(schema, params, all_fields -- embed_fields -- assoc_fields)

    changeset =
      Enum.reduce(embed_fields, changeset, fn embed_field, changeset ->
        Ecto.Changeset.cast_embed(changeset, embed_field, with: &changeset/2)
      end)

    changeset
  end
end
