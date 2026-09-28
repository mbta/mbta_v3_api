defmodule Util.Task do
  @moduledoc "Task-related utilities"

  require Logger

  @doc """
  Takes a map of tasks and calls &Task.yield_many/2 on them, then rebuilds the map with
  either the result of the task, or the default if the task times out or exits early.
  """
  @type task_map :: %{optional(Task.t()) => {atom, any}}
  @spec yield_or_default_many(task_map, atom, non_neg_integer) :: map
  def yield_or_default_many(%{} = task_map, module, timeout \\ 5000) when is_atom(module) do
    task_map
    |> Map.keys()
    |> Task.yield_many(timeout)
    |> Map.new(&do_yield_or_default_many(&1, task_map, module))
  end

  @spec do_yield_or_default_many({Task.t(), {:ok, any} | {:exit, term} | nil}, task_map, atom) ::
          {atom, any}
  defp do_yield_or_default_many({%Task{} = task, result}, task_map, module) do
    {key, default} = Map.get(task_map, task)
    {key, task_result_or_default(result, default, task, module, key)}
  end

  @spec task_result_or_default({:ok, any} | {:exit, term} | nil, any, Task.t(), atom, any) :: any
  defp task_result_or_default({:ok, result}, _default, _task, _module, _key) do
    result
  end

  defp task_result_or_default({:exit, reason}, default, _task, module, key) do
    _ =
      Logger.warning(
        "module=#{module} " <>
          "key=#{key} " <>
          "error=async_error " <>
          "error_type=timeout " <>
          "Async task exited for reason: #{inspect(reason)} -- Defaulting to: #{inspect(default)}"
      )

    default
  end

  defp task_result_or_default(nil, default, %Task{} = task, module, key) do
    case Task.shutdown(task, :brutal_kill) do
      {:ok, result} ->
        result

      _ ->
        _ =
          Logger.warning(
            "module=#{module} " <>
              "key=#{key} " <>
              "error=async_error " <>
              "error_type=timeout " <>
              "Async task timed out -- Defaulting to: #{inspect(default)}"
          )

        default
    end
  end
end
