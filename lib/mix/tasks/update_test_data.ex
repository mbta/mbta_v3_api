unless is_nil(Application.compile_env(:mbta_v3_api, :req_plug)) do
  defmodule Mix.Tasks.UpdateTestData do
    @moduledoc "Update cached test data based on API calls in tests"

    use Mix.Task
    @shortdoc "Updates test data cache"
    @requirements ["app.config"]

    @impl Mix.Task
    def run(_) do
      Application.put_env(:mbta_v3_api, :updating_test_data?, true)

      MBTAV3APITest.Data.start_link()

      Mix.Task.run("test", ["--raise"])

      MBTAV3APITest.Data.write_new_data()
    end
  end
end
