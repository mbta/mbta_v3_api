# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.TripResource do
  @moduledoc """
  Representation of the journey of a particular vehicle through a given set of stops. See [GTFS `trips.txt`](https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#tripstxt) 
  """

  @derive Jason.Encoder
  defstruct [
    :type,
    :relationships,
    :links,
    :id,
    :attributes
  ]

  @type t :: %__MODULE__{
    :type => String.t | nil,
    :relationships => MBTA.Model.TripResourceRelationships.t | nil,
    :links => map() | nil,
    :id => String.t | nil,
    :attributes => MBTA.Model.TripResourceAttributes.t | nil
  }

  alias MBTA.Deserializer

  def decode(value) do
    value
     |> Deserializer.deserialize(:relationships, :struct, MBTA.Model.TripResourceRelationships)
     |> Deserializer.deserialize(:attributes, :struct, MBTA.Model.TripResourceAttributes)
  end
end

