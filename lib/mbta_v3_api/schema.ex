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
      (relationships || [])
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

  @spec hydrate_cache(Ecto.Schema.embedded_schema(), list(atom())) ::
          {:ok, Ecto.Schema.embedded_schema()} | :error
  def hydrate_cache(cached_object, include) do
    %module{} = cached_object

    for include_field <- include, reduce: {:ok, cached_object} do
      {:ok, %^module{^include_field => %Ecto.Association.NotLoaded{}} = object} ->
        case Map.fetch(object, :"#{include_field}_id") do
          {:ok, include_id} ->
            include_type = module.__schema__(:association, include_field).related

            case MBTAV3API.Cache.get(include_type, include_id) do
              {:ok, include_result} -> {:ok, struct!(object, {include_field, include_result})}
              :error -> :error
            end

          :error ->
            :error
        end

      {:ok, %^module{^include_field => include_result} = object} when is_struct(include_result) ->
        {:ok, object}

      :error ->
        :error
    end
  end

  @spec put_cache(Ecto.Schema.embedded_schema()) :: :ok
  def put_cache(object) do
    %module{} = object
    assoc_fields = module.__schema__(:associations)

    empty_assocs = struct!(module) |> Map.take(assoc_fields)

    object_without_assocs = struct!(object, empty_assocs)

    MBTAV3API.Cache.put(
      object_without_assocs,
      # TODO think about TTL
      case module do
        MBTAV3API.Alert -> :timer.minutes(5)
        MBTAV3API.Facility -> :timer.hours(24)
        MBTAV3API.Stop -> :timer.hours(24)
      end
    )

    object
    |> Map.take(assoc_fields)
    |> Enum.map(fn
      {_, nil} -> :ok
      {_, %Ecto.Association.NotLoaded{}} -> :ok
      {_, assoc_objects} when is_list(assoc_objects) -> Enum.map(assoc_objects, &put_cache/1)
      {_, assoc_object} when is_struct(assoc_object) -> put_cache(assoc_object)
    end)

    :ok
  end
end
