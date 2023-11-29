defmodule MBTAV3API.Facilities.Supervisor do
  @moduledoc """
  Supervisor for the facilities repo.
  """

  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      MBTAV3API.Facilities.Repo
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
