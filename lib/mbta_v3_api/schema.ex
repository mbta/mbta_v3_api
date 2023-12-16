defmodule MBTAV3API.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :string, []}
      @foreign_key_type :string
    end
  end
end
