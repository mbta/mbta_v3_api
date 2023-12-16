defmodule MBTAV3API.JSONAPI.ResourceIdentifier do
  @type t :: %__MODULE__{
          type: String.t(),
          id: String.t()
        }

  defstruct [:type, :id]

  def parse!(data) do
    %__MODULE__{
      type: data["type"],
      id: data["id"]
    }
  end
end
