defmodule MBTAV3API.EctoType.GTFSOptionalBoolean do
  @moduledoc """
  For various reasons, GTFS optional booleans have 0 nil, 1 true, 2 false.
  """
  use Ecto.Type

  @impl true
  def type, do: :boolean

  @impl true
  def cast(0), do: {:ok, nil}
  def cast(1), do: {:ok, true}
  def cast(2), do: {:ok, false}
  def cast(_), do: :error

  @impl true
  def load(x) when is_boolean(x), do: {:ok, x}

  @impl true
  def dump(x) when is_boolean(x), do: {:ok, x}
  def dump(_), do: :error
end
