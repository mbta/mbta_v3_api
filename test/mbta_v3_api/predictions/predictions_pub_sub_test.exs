defmodule MBTAV3API.Predictions.PredictionsPubSubTest do
  use ExUnit.Case, async: false

  import Mock
  import Test.Support.Helpers

  alias MBTAV3API.Predictions.{Prediction, PredictionsPubSub, Store, StreamSupervisor}
  alias MBTAV3API.RoutePatterns.Repo, as: RoutePatternsRepo
  alias MBTAV3API.RoutePatterns.RoutePattern
  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Stops.Stop

  @stop_id "place-where"
  @prediction39 %Prediction{
    id: "prediction39",
    direction_id: 1,
    route: %Route{id: "39"},
    stop: %Stop{id: @stop_id}
  }
  @channel_args "stop:#{@stop_id}"

  setup_all do
    reassign_system_env("USE_SERVER_SENT_EVENTS", "true")
    start_supervised({Registry, keys: :duplicate, name: :prediction_subscriptions_registry})
    start_supervised({Store, name: :pub_sub_test_store})

    :ok
  end

  setup_with_mocks([
    {RoutePatternsRepo, [:passthrough], [by_stop_id: fn _stop_id -> [%RoutePattern{}] end]}
  ]) do
    subscribe_fn = fn _, _ -> :ok end
    {:ok, pid} = PredictionsPubSub.start_link(name: :subscribe, subscribe_fn: subscribe_fn)

    {:ok, pid: pid}
  end

  defp close_active_workers(context) do
    StreamSupervisor
    |> DynamicSupervisor.which_children()
    |> Enum.each(&DynamicSupervisor.terminate_child(StreamSupervisor, elem(&1, 1)))

    context
  end

  setup :close_active_workers

  describe "subscribe/2" do
    test "clients get existing predictions upon subscribing", %{pid: pid} do
      with_mock(Store, [:passthrough], fetch: fn _keys -> [@prediction39] end) do
        assert PredictionsPubSub.subscribe(@channel_args, pid) == [@prediction39]
      end
    end
  end
end
