# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.StopResource do
  @moduledoc """
  Physical location where transit can pick-up or drop-off passengers. See https://github.com/google/transit/blob/master/gtfs/spec/en/reference.md#stopstxt for more details and https://github.com/mbta/gtfs-documentation/blob/master/reference/gtfs.md#stopstxt for specific extensions.
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
    :relationships => MBTA.Model.StopResourceRelationships.t | nil,
    :links => map() | nil,
    :id => String.t | nil,
    :attributes => MBTA.Model.StopResourceAttributes.t | nil
  }

  alias MBTA.Deserializer

  def decode(value) do
    value
     |> Deserializer.deserialize(:relationships, :struct, MBTA.Model.StopResourceRelationships)
     |> Deserializer.deserialize(:attributes, :struct, MBTA.Model.StopResourceAttributes)
  end
end

