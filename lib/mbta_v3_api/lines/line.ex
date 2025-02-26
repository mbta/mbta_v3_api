defmodule MBTAV3API.Lines.Line do
  @moduledoc """
  A line.
  """

  @derive Jason.Encoder
  alias MBTAV3API.Routes.Route

  defstruct [
    :id,
    :name,
    :long_name,
    :sort_order,
    :route_ids,
    :routes
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          long_name: String.t(),
          name: String.t(),
          sort_order: integer(),
          route_ids: [Route.id_t()],
          routes: [Route.t()]
        }
end
