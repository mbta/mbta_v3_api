# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.PredictionResourceRelationshipsRouteData do
  @moduledoc """
  
  """

  @derive Jason.Encoder
  defstruct [
    :type,
    :id
  ]

  @type t :: %__MODULE__{
    :type => String.t | nil,
    :id => String.t | nil
  }

  def decode(value) do
    value
  end
end

