defmodule Util.TaskTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  describe "yield_or_default_many/2" do
    test "returns result when task does not timeout, and default when it does" do
      short_fn = fn -> :task_result end
      long_fn = fn -> :timer.sleep(1_000) end
      aborted_task = Task.async(long_fn)

      task_map = %{
        Task.async(short_fn) => {:short, :short_default},
        Task.async(long_fn) => {:long, :long_default},
        aborted_task => {:aborted, :aborted_default}
      }

      Process.unlink(aborted_task.pid)
      Process.exit(aborted_task.pid, :kill)

      log =
        capture_log(fn ->
          assert Util.Task.yield_or_default_many(task_map, __MODULE__, 500) == %{
                   short: :task_result,
                   long: :long_default,
                   aborted: :aborted_default
                 }
        end)

      assert log =~ "Defaulting to: :long_default"
      assert log =~ "exited for reason: :killed"
      refute log =~ "Defaulting to: :short_default"
    end
  end
end
