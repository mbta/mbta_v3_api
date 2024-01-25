defmodule MBTAV3API.Schedules.Parser do
  @moduledoc """
  Parse API data into Schedule structs.
  """

  require MBTAV3API.Routes.Route
  alias JsonApi.Item
  alias MBTAV3API.Routes.Repo, as: RoutesRepo
  alias MBTAV3API.Routes.Route
  alias MBTAV3API.Schedules.Trip
  alias MBTAV3API.Stops.Stop

  @type record :: {
          route_id :: Route.id_t(),
          trip_id :: String.t(),
          stop_id :: Stop.id_t(),
          arrival_time :: DateTime.t() | nil,
          departure_time :: DateTime.t() | nil,
          time :: DateTime.t(),
          flag? :: boolean,
          early_departure? :: boolean,
          last_stop? :: boolean,
          stop_sequence :: integer,
          pickup_type :: integer
        }

  @spec parse(Item.t()) :: record
  def parse(item) do
    arrival = arrival_time(item)
    departure = departure_time(item)
    route_id = route_id(item)

    {
      route_id(item),
      trip_id(item),
      stop_id(item),
      arrival,
      departure,
      display_time(arrival, departure, route_id),
      flag?(item),
      early_departure?(item),
      last_stop?(item),
      item.attributes["stop_sequence"] || 0,
      pickup_type(item)
    }
  end

  def route_id(%Item{relationships: %{"route" => [%Item{id: id} | _]}}) do
    id
  end

  def trip_id(%Item{relationships: %{"trip" => [%Item{id: id} | _]}}) do
    id
  end

  def trip(%Item{
        relationships: %{
          "trip" => [
            %Item{
              id: id,
              attributes:
                %{"name" => name, "headsign" => headsign, "direction_id" => direction_id} =
                  attributes,
              relationships: relationships
            }
            | _
          ]
        }
      }) do
    %Trip{
      id: id,
      headsign: headsign,
      name: name,
      direction_id: direction_id,
      bikes_allowed?: bikes_allowed?(attributes),
      route_pattern_id: route_pattern_id(relationships),
      shape_id: shape_id(relationships),
      occupancy: occupancy(relationships)
    }
  end

  def trip(%JsonApi{
        data: [
          %Item{
            id: id,
            attributes:
              %{
                "headsign" => headsign,
                "name" => name,
                "direction_id" => direction_id
              } = attributes,
            relationships: relationships
          }
        ]
      }) do
    %Trip{
      id: id,
      headsign: headsign,
      name: name,
      direction_id: direction_id,
      shape_id: shape_id(relationships),
      route_pattern_id: route_pattern_id(relationships),
      bikes_allowed?: bikes_allowed?(attributes),
      occupancy: occupancy(relationships)
    }
  end

  def trip(%Item{relationships: %{"trip" => _}}) do
    nil
  end

  def stop_id(%Item{
        relationships: %{
          "stop" => [
            %Item{id: id}
          ]
        }
      }) do
    id
  end

  defp arrival_time(%Item{attributes: %{"arrival_time" => time}}) when time != nil do
    Timex.parse!(time, "{ISO:Extended}")
  end

  defp arrival_time(_), do: nil

  defp departure_time(%Item{attributes: %{"departure_time" => time}}) when time != nil do
    Timex.parse!(time, "{ISO:Extended}")
  end

  defp departure_time(_), do: nil

  @doc """
  Prefer arrival times for subway and bus, and departure times for all other modes.
  """
  @spec display_time(DateTime.t() | nil, DateTime.t() | nil, Route.id_t() | Route.t() | nil) ::
          DateTime.t() | nil
  def display_time(arrival_time, departure_time, %Route{id: route_id, type: route_type})
      when Route.subway?(route_type, route_id) or route_type === 3 do
    if(arrival_time, do: arrival_time, else: departure_time)
  end

  def display_time(arrival_time, departure_time, route_id) when is_binary(route_id) do
    route = RoutesRepo.get(route_id)
    display_time(arrival_time, departure_time, route)
  end

  def display_time(arrival_time, departure_time, _) do
    if(departure_time, do: departure_time, else: arrival_time)
  end

  defp flag?(%Item{
         attributes: %{"pickup_type" => pickup_type, "drop_off_type" => drop_off_type}
       }) do
    # https://developers.google.com/transit/gtfs/reference/stop_times-file
    # defines pickup_type and drop_off_type:
    # * 0: Regularly scheduled drop off
    # * 1: No drop off available
    # * 2: Must phone agency to arrange drop off
    # * 3: Must coordinate with driver to arrange drop off
    # Flag trips are those which need coordination.
    pickup_type == 3 || drop_off_type == 3
  end

  defp early_departure?(%Item{
         attributes: %{"pickup_type" => pickup_type, "timepoint" => timepoint}
       }) do
    # early departure when the timepoint is false and the pickup_type is not 1
    timepoint == false && pickup_type != 1
  end

  defp last_stop?(%Item{
         attributes: %{
           "drop_off_type" => dropoff,
           "pickup_type" => pickup
         }
       }) do
    dropoff === 0 and pickup === 1
  end

  defp pickup_type(%Item{attributes: %{"pickup_type" => pickup_type}}) do
    pickup_type
  end

  @spec shape_id(any) :: String.t() | nil
  defp shape_id(%{"shape" => [%Item{id: id}]}), do: id
  defp shape_id(_), do: nil

  @spec route_pattern_id(any) :: String.t() | nil
  defp route_pattern_id(%{"route_pattern" => [%Item{id: id}]}), do: id
  defp route_pattern_id(_), do: nil

  @spec bikes_allowed?(map) :: boolean
  defp bikes_allowed?(%{"bikes_allowed" => 1}), do: true
  defp bikes_allowed?(_), do: false

  @spec occupancy(any) :: Trip.crowding() | nil
  defp occupancy(%{
         "occupancies" => [%Item{attributes: %{"status" => status}}]
       }) do
    case status do
      "MANY_SEATS_AVAILABLE" -> :not_crowded
      "FEW_SEATS_AVAILABLE" -> :some_crowding
      "FULL" -> :crowded
      _ -> nil
    end
  end

  defp occupancy(_), do: nil
end
