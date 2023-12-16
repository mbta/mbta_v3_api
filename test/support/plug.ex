defmodule MBTAV3APITest.Plug do
  @behaviour Plug

  @impl Plug
  def init(_opts), do: []

  @impl Plug
  def call(conn, _opts) do
    MBTAV3APITest.Data.respond(conn)
  end
end
