# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.StopResourceAttributes do
  @moduledoc """
  
  """

  @derive Jason.Encoder
  defstruct [
    :wheelchair_boarding,
    :name,
    :longitude,
    :location_type,
    :latitude
  ]

  @type t :: %__MODULE__{
    :wheelchair_boarding => integer() | nil,
    :name => String.t | nil,
    :longitude => float() | nil,
    :location_type => integer() | nil,
    :latitude => float() | nil
  }

  def decode(value) do
    value
  end
end
