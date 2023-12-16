Application.ensure_all_started(:mbta_v3_api)

case MBTAV3APITest.Data.start_link() do
  {:ok, _} -> :ok
  {:error, {:already_started, _}} -> :ok
end

ExUnit.start()

System.at_exit(fn _ -> MBTAV3APITest.Data.warn_untouched() end)
