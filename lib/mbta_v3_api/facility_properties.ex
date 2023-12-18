defmodule MBTAV3API.FacilityProperties do
  use MBTAV3API.Schema

  @primary_key false

  embedded_schema do
    field(:address, :string)
    field(:alternate_service_text, :string)
    field(:attended, :boolean)
    field(:capacity, :integer)
    field(:capacity_accessible, :integer)
    field(:car_sharing, {:array, :string})
    field(:contact, :string)
    field(:contact_phone, :string)
    field(:contact_url, :string)
    field(:direction, Ecto.Enum, values: [:up, :down])
    field(:dispenses, :string)
    field(:enclosed, :boolean)
    field(:excludes_stop, {:array, :string})
    field(:fee_daily, :string)
    field(:fee_monthly, :string)
    field(:municipality, :string)
    field(:note, :string)
    field(:operator, :string)
    field(:overnight_allowed, Ecto.Enum, values: [:yes, :no, :yes_except_snow, :yes_snow_unknown])
    field(:owner, :string)
    field(:payment_app, :string)
    field(:payment_app_id, :string)
    field(:payment_app_url, :string)

    field(:payment_form_accepted, {:array, Ecto.Enum},
      values: [
        :cash,
        :check,
        :coin,
        :credit_debit_card,
        :e_zpass,
        :invoice,
        :mobile_app,
        :smartcard
      ]
    )

    field(:secured, :boolean)
    field(:weekday_arrive_before, :string)
    field(:weekday_typical_utilization, :integer)
    field(:weekday_utilization_summary, :string)
  end

  def parse!(data) do
    data = Enum.group_by(data, & &1["name"], & &1["value"])

    __schema__(:fields)
    |> Map.new(&unpack(data, &1))
    |> then(&struct!(__MODULE__, &1))
  end

  defguardp is_single_type(type)
            when is_atom(type) or (elem(type, 0) == :parameterized and elem(type, 1) == Ecto.Enum)

  defp unpack(data, property) do
    data_name = to_string(property) |> String.replace("_", "-")
    data_values = Map.get(data, data_name, [])

    elixir_type = __schema__(:type, property)

    do_parse = fn type, v ->
      try do
        parse_value!(type, v)
      rescue
        ArgumentError ->
          type =
            case type do
              {:parameterized, Ecto.Enum, _} -> :enum
              _ -> type
            end

          reraise "Got bad #{type} #{inspect(v)} for facility property #{property}",
                  __STACKTRACE__
      end
    end

    value =
      case {elixir_type, data_values} do
        {type, []} when is_single_type(type) ->
          nil

        {type, [v]} when is_single_type(type) ->
          do_parse.(type, v)

        {type, vs} when is_single_type(type) ->
          raise "Got #{length(vs)} values for single-value facility property #{property}"

        {{:array, type}, vs} ->
          Enum.map(vs, fn v -> do_parse.(type, v) end)
      end

    {property, value}
  end

  defp parse_value!(type, value)

  defp parse_value!(:string, v) when is_binary(v), do: v
  defp parse_value!(:string, _), do: raise(ArgumentError)

  defp parse_value!(:boolean, 0), do: nil
  defp parse_value!(:boolean, 1), do: true
  defp parse_value!(:boolean, 2), do: false
  defp parse_value!(:boolean, _), do: raise(ArgumentError)

  defp parse_value!(:integer, v) when is_integer(v), do: v
  defp parse_value!(:integer, _), do: raise(ArgumentError)

  defp parse_value!({:parameterized, Ecto.Enum, params}, v) do
    unless is_binary(v) do
      raise ArgumentError
    end

    v
    |> String.replace("-", "_")
    |> then(&Ecto.Enum.cast(&1, params))
    |> case do
      {:ok, result} -> result
      _ -> raise ArgumentError
    end
  end
end
