defmodule MBTAV3API.StreamTest do
  use ExUnit.Case, async: false

  import Test.Support.Helpers

  alias MBTAV3API.Stream
  alias MBTAV3API.Stream.Event
  alias Plug.Conn

  describe "start_link/1" do
    setup do
      reassign_env(:mbta_v3_api, :base_url, "http://example.com")
      reassign_env(:mbta_v3_api, :api_key, "12345678")
      reassign_env(:mbta_v3_api, :api_version, "3005-01-02")

      bypass = Bypass.open()

      {:ok, %{bypass: bypass}}
    end

    @tag :capture_log
    test "starts a genserver that sends events", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        conn = Conn.send_chunked(conn, 200)

        data = %{
          "attributes" => [],
          "type" => "vehicle",
          "id" => "vehicle"
        }

        Conn.chunk(conn, "event: reset\ndata: #{Jason.encode!([data])}\n\n")
        conn
      end)

      assert {:ok, sses} =
               [
                 name: :start_link_test,
                 base_url: "http://localhost:#{bypass.port}",
                 path: "/alerts",
                 params: []
               ]
               |> Stream.build_options()
               |> ServerSentEventStage.start_link()

      assert {:ok, pid} = Stream.start_link(name: __MODULE__, subscribe_to: sses)

      assert [%Event{}] =
               [pid]
               |> GenStage.stream()
               |> Enum.take(1)
    end

    @tag :capture_log
    test "handles api events", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        conn = Conn.send_chunked(conn, 200)

        data = %{
          "attributes" => [],
          "type" => "vehicle",
          "id" => "vehicle"
        }

        Conn.chunk(conn, "event: reset\ndata: #{Jason.encode!([data])}\n\n")
        Conn.chunk(conn, "event: add\ndata: #{Jason.encode!(data)}\n\n")
        Conn.chunk(conn, "event: update\ndata: #{Jason.encode!(data)}\n\n")
        Conn.chunk(conn, "event: remove\ndata: #{Jason.encode!(data)}\n\n")
        conn
      end)

      assert {:ok, sses} =
               [
                 base_url: "http://localhost:#{bypass.port}",
                 path: "/alerts"
               ]
               |> Stream.build_options()
               |> ServerSentEventStage.start_link()

      assert {:ok, pid} = Stream.start_link(name: __MODULE__, subscribe_to: sses)

      stream = GenStage.stream([pid])

      assert [
               %Event{event: :reset},
               %Event{event: :add},
               %Event{event: :update},
               %Event{event: :remove}
             ] = Enum.take(stream, 4)
    end
  end

  describe "build_options" do
    setup do
      reassign_env(:mbta_v3_api, :base_url, "TEST_BASE_URL")
      reassign_env(:mbta_v3_api, :api_key, "TEST_API_KEY")
    end

    test "sets the URL based on the configured base URL" do
      opts = Stream.build_options(path: "/vehicles")

      assert Keyword.get(opts, :url) == "TEST_BASE_URL/vehicles"
    end

    test "includes API base URL and key" do
      opts = Stream.build_options(path: "/vehicles")

      assert Keyword.get(opts, :api_key) == "TEST_API_KEY"
    end
  end

  describe "init/1" do
    test "defines itself as a `producer_consumer` subscribed to the producer" do
      mock_producer = "MOCK_PRODUCER"
      opts = [subscribe_to: mock_producer]

      assert Stream.init(opts) == {:producer_consumer, %{}, subscribe_to: [mock_producer]}
    end
  end
end
