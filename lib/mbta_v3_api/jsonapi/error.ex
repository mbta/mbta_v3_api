defmodule MBTAV3API.JSONAPI.Error do
  @type t :: %__MODULE__{
          title: String.t() | nil,
          status: String.t() | nil,
          source: term() | nil,
          code: String.t() | nil
        }

  defstruct [:title, :status, :source, :code]
end
