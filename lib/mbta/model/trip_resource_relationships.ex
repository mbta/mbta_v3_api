# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.TripResourceRelationships do
  @moduledoc """
  
  """

  @derive Jason.Encoder
  defstruct [
    :shape,
    :service,
    :route_pattern,
    :route,
    :occupancy
  ]

  @type t :: %__MODULE__{
    :shape => MBTA.Model.TripResourceRelationshipsShape.t | nil,
    :service => MBTA.Model.TripResourceRelationshipsService.t | nil,
    :route_pattern => MBTA.Model.TripResourceRelationshipsRoutePattern.t | nil,
    :route => MBTA.Model.PredictionResourceRelationshipsRoute.t | nil,
    :occupancy => MBTA.Model.TripResourceRelationshipsOccupancy.t | nil
  }

  alias MBTA.Deserializer

  def decode(value) do
    value
     |> Deserializer.deserialize(:shape, :struct, MBTA.Model.TripResourceRelationshipsShape)
     |> Deserializer.deserialize(:service, :struct, MBTA.Model.TripResourceRelationshipsService)
     |> Deserializer.deserialize(:route_pattern, :struct, MBTA.Model.TripResourceRelationshipsRoutePattern)
     |> Deserializer.deserialize(:route, :struct, MBTA.Model.PredictionResourceRelationshipsRoute)
     |> Deserializer.deserialize(:occupancy, :struct, MBTA.Model.TripResourceRelationshipsOccupancy)
  end
end

