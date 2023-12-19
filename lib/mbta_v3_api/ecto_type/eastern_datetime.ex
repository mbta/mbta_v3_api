defmodule MBTAV3API.EctoType.EasternDatetime do
  use Ecto.Type

  def type, do: :utc_datetime

  def cast(value) when is_binary(value) do
    case DateTime.from_iso8601(value) do
      {:ok, utc_datetime, expected_offset} ->
        case cast(utc_datetime) do
          {:ok, result} ->
            result_offset = result.utc_offset + result.std_offset

            if result_offset == expected_offset do
              {:ok, result}
            else
              actual =
                Calendar.ISO.offset_to_string(result.utc_offset, result.std_offset, "", :extended)

              expected = Calendar.ISO.offset_to_string(expected_offset, 0, "", :extended)
              {:error, message: "has weird offset #{actual} instead of #{expected}"}
            end

          :error ->
            :error
        end
    end
  end

  def cast(%DateTime{} = value) do
    case value.time_zone do
      "America/New_York" ->
        {:ok, value}

      _ ->
        case DateTime.shift_zone(value, "America/New_York") do
          {:ok, x} -> {:ok, x}
          {:error, _} -> :error
        end
    end
  end

  def cast(_), do: :error

  def load(%DateTime{} = data) do
    cast(data)
  end

  def dump(%DateTime{} = data) do
    {:ok, DateTime.shift_zone!(data, "Etc/UTC")}
  end

  def dump(_), do: :error
end
