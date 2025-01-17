defmodule MBTAV3API.Lines.Line do
  @moduledoc """
  A line.
  """

  @derive Jason.Encoder

  defstruct [
    :id,
    :name,
    :long_name,
    :sort_order,
    :route_ids
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          long_name: String.t(),
          name: String.t(),
          sort_order: integer(),
          route_ids: [String.t()]
        }
end
