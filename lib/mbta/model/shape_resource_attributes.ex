# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.ShapeResourceAttributes do
  @moduledoc """
  
  """

  @derive Jason.Encoder
  defstruct [
    :polyline
  ]

  @type t :: %__MODULE__{
    :polyline => String.t | nil
  }

  def decode(value) do
    value
  end
end

