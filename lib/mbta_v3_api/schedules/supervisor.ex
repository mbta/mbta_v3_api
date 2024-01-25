defmodule MBTAV3API.Schedules.Supervisor do
  @moduledoc """
  Supervisor for the schedules repo.
  """

  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      MBTAV3API.Schedules.Repo
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
