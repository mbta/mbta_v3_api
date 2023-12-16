defmodule MBTAV3API.JSONAPI.Links do
  @type t :: %__MODULE__{
          self: String.t() | nil,
          related: String.t() | nil,
          first: String.t() | nil,
          last: String.t() | nil,
          prev: String.t() | nil,
          next: String.t() | nil
        }
  defstruct [:self, :related, :first, :last, :prev, :next]

  def parse!(nil), do: nil

  def parse!(data) when is_map(data) do
    %__MODULE__{
      self: data["self"],
      related: data["related"],
      first: data["first"],
      last: data["last"],
      prev: data["prev"],
      next: data["next"]
    }
  end
end
