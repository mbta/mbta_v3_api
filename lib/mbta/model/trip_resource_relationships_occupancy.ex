# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.TripResourceRelationshipsOccupancy do
  @moduledoc """
  
  """

  @derive Jason.Encoder
  defstruct [
    :links,
    :data
  ]

  @type t :: %__MODULE__{
    :links => MBTA.Model.TripResourceRelationshipsOccupancyLinks.t | nil,
    :data => MBTA.Model.TripResourceRelationshipsOccupancyData.t | nil
  }

  alias MBTA.Deserializer

  def decode(value) do
    value
     |> Deserializer.deserialize(:links, :struct, MBTA.Model.TripResourceRelationshipsOccupancyLinks)
     |> Deserializer.deserialize(:data, :struct, MBTA.Model.TripResourceRelationshipsOccupancyData)
  end
end

