defmodule MBTAV3API.Predictions.StreamSupervisorTest do
  use ExUnit.Case

  import Test.Support.Helpers

  alias MBTAV3API.Predictions.StreamSupervisor
  alias MBTAV3API.Predictions.StreamSupervisor.Worker

  setup_all do
    reassign_system_env("USE_SERVER_SENT_EVENTS", "true")
    reassign_env(:mbta_v3_api, :base_url, "http://example.com")
    reassign_env(:mbta_v3_api, :api_key, "12345678")
    :ok
  end

  defp close_active_workers(context) do
    StreamSupervisor
    |> DynamicSupervisor.which_children()
    |> Enum.each(&DynamicSupervisor.terminate_child(StreamSupervisor, elem(&1, 1)))

    context
  end

  setup :close_active_workers

  describe "start_link/1" do
    test "StreamSupervisor is started along with registry" do
      assert {:error, {:already_started, _}} = StreamSupervisor.start_link([])

      assert {:error, {:already_started, _}} =
               Registry.start_link(keys: :unique, name: :prediction_streams_registry)
    end
  end

  describe "init/1" do
    test "StreamSupervisor runs DynamicSupervisor.init" do
      {:ok, %{strategy: :one_for_one}} = StreamSupervisor.init([])
    end
  end

  describe "ensure_stream_is_started/1" do
    @tag :capture_log
    test "starts a stream if not already started" do
      filter_key =
        {[route: "Purple", direction: 1], "filter[route]=Purple&filter[direction_id]=1"}

      assert {:ok, _pid} = StreamSupervisor.ensure_stream_is_started(filter_key)
    end

    @tag :capture_log
    test "returns existing stream from registry" do
      filter_key = {[route: "Pink", direction: 0], "filter[route]=Pink&filter[direction_id]=0"}
      {:ok, pid} = StreamSupervisor.ensure_stream_is_started(filter_key)
      assert {:ok, ^pid} = StreamSupervisor.ensure_stream_is_started(filter_key)
    end
  end

  describe "stop_stream/1" do
    @tag :capture_log
    test "closes a stream by registered key" do
      filter_key = {[route: "Teal", direction: 1], "filter[route]=Teal&filter[direction_id]=1"}
      {:ok, pid} = StreamSupervisor.ensure_stream_is_started(filter_key)
      assert Process.alive?(pid)

      assert [{_, ^pid, :supervisor, [Worker]}] =
               DynamicSupervisor.which_children(StreamSupervisor)

      :ok = StreamSupervisor.stop_stream(elem(filter_key, 1))
      refute Process.alive?(pid)
      assert [] = DynamicSupervisor.which_children(StreamSupervisor)
    end
  end
end
