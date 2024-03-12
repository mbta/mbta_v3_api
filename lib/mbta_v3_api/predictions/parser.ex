defmodule MBTAV3API.Predictions.Parser do
  @moduledoc """
  Functions for parsing predictions from their JSON:API format.
  """

  alias JsonApi.Item
  alias MBTAV3API.Predictions.Prediction
  alias MBTAV3API.Schedules.Parser, as: SchedulesParser
  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Schedules.Trip
  alias MBTAV3API.Vehicles.Vehicle

  @type record :: {
          Prediction.id_t() | nil,
          Trip.id_t() | nil,
          Stops.Stop.id_t(),
          Route.id_t(),
          0 | 1,
          DateTime.t() | nil,
          DateTime.t() | nil,
          DateTime.t() | nil,
          non_neg_integer,
          Prediction.schedule_relationship() | nil,
          String.t() | nil,
          String.t() | nil,
          boolean,
          Vehicle.id_t() | nil
        }

  @spec parse(Item.t()) :: record
  def parse(%Item{} = item) do
    arrival = arrival_time(item)
    departure = departure_time(item)
    route_id = route_id(item)

    {
      item.id,
      trip_id(item),
      stop_id(item),
      route_id,
      direction_id(item),
      arrival,
      departure,
      SchedulesParser.display_time(arrival, departure, route_id),
      stop_sequence(item),
      schedule_relationship(item),
      track(item),
      status(item),
      departing?(item),
      vehicle_id(item)
    }
  end

  @spec departing?(Item.t()) :: boolean()
  def departing?(%Item{attributes: %{"departure_time" => binary}}) when is_binary(binary),
    do: true

  def departing?(%Item{attributes: %{"status" => binary}}) when is_binary(binary),
    do: upcoming_status?(binary)

  def departing?(_), do: false

  @spec direction_id(Item.t()) :: 0 | 1
  def direction_id(%Item{attributes: %{"direction_id" => direction_id}}), do: direction_id

  @spec departure_time(Item.t()) :: DateTime.t() | nil
  def departure_time(%Item{attributes: %{"departure_time" => departure_time}})
      when not is_nil(departure_time),
      do: parse_time(departure_time)

  def departure_time(_), do: nil

  @spec arrival_time(Item.t()) :: DateTime.t() | nil
  def arrival_time(%Item{attributes: %{"arrival_time" => arrival_time}})
      when not is_nil(arrival_time),
      do: parse_time(arrival_time)

  def arrival_time(_), do: nil

  @spec schedule_relationship(Item.t()) :: Prediction.schedule_relationship() | nil
  def schedule_relationship(%Item{attributes: %{"schedule_relationship" => "ADDED"}}), do: :added

  def schedule_relationship(%Item{attributes: %{"schedule_relationship" => "UNSCHEDULED"}}),
    do: :unscheduled

  def schedule_relationship(%Item{attributes: %{"schedule_relationship" => "CANCELLED"}}),
    do: :cancelled

  def schedule_relationship(%Item{attributes: %{"schedule_relationship" => "SKIPPED"}}),
    do: :skipped

  def schedule_relationship(%Item{attributes: %{"schedule_relationship" => "NO_DATA"}}),
    do: :no_data

  def schedule_relationship(_), do: nil

  @spec status(Item.t()) :: String.t() | nil
  def status(%Item{attributes: %{"status" => status}}), do: status
  def status(_), do: nil

  @spec stop_sequence(Item.t()) :: non_neg_integer()
  def stop_sequence(%Item{attributes: %{"stop_sequence" => stop_sequence}}), do: stop_sequence
  def stop_sequence(_), do: 0

  @spec track(Item.t()) :: String.t() | nil
  def track(%{attributes: %{"track" => track}}), do: track

  def track(%{relationships: %{"stop" => [%{attributes: %{"platform_code" => track}} | _]}}),
    do: track

  def track(_), do: nil

  defp parse_time(prediction_time) do
    case Timex.parse(prediction_time, "{ISO:Extended}") do
      {:ok, time} ->
        time

      _ ->
        nil
    end
  end

  @spec upcoming_status?(String.t()) :: boolean
  defp upcoming_status?("Approaching"), do: true
  defp upcoming_status?("Boarding"), do: true
  defp upcoming_status?(status), do: String.ends_with?(status, "away")

  defp stop_id(%Item{relationships: %{"stop" => [%{id: id} | _]}}) do
    id
  end

  defp stop_id(%Item{relationships: %{"stop" => []}}) do
    nil
  end

  defp trip_id(%Item{relationships: %{"trip" => [%{id: id} | _]}}) do
    id
  end

  defp trip_id(%Item{relationships: %{"trip" => []}}) do
    nil
  end

  defp route_id(%Item{relationships: %{"route" => [%{id: id} | _]}}) do
    id
  end

  defp vehicle_id(%Item{relationships: %{"vehicle" => [%{id: id} | _]}}) do
    id
  end

  defp vehicle_id(%Item{relationships: %{"vehicle" => []}}) do
    nil
  end
end
