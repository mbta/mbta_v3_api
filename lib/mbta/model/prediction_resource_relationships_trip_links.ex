# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.PredictionResourceRelationshipsTripLinks do
  @moduledoc """
  
  """

  @derive Jason.Encoder
  defstruct [
    :self,
    :related
  ]

  @type t :: %__MODULE__{
    :self => String.t | nil,
    :related => String.t | nil
  }

  def decode(value) do
    value
  end
end

