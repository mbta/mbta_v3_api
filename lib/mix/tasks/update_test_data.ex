unless is_nil(Application.compile_env(:mbta_v3_api, :req_plug)) do
  defmodule Mix.Tasks.UpdateTestData do
    @moduledoc """
    Update cached test data based on API calls in tests.

    Forwards arguments (such as specific tests to run) to `mix test`.
    Only writes if run with no arguments.
    """

    use Mix.Task
    @shortdoc "Updates test data cache"
    @requirements ["app.config"]

    @impl Mix.Task
    def run(args) do
      Application.put_env(:mbta_v3_api, :updating_test_data?, true)

      MBTAV3APITest.Data.start_link()

      Mix.Task.run("test", ["--raise"] ++ args)

      if args == [] do
        MBTAV3APITest.Data.write_new_data()
      else
        Mix.shell().info("Not writing test data, ran with arguments")
      end
    end
  end
end
