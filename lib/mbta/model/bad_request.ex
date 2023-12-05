# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.BadRequest do
  @moduledoc """
  A JSON-API error document when the server cannot or will not process the request due to something that is perceived to be a client error. 
  """

  @derive Jason.Encoder
  defstruct [
    :errors
  ]

  @type t :: %__MODULE__{
    :errors => [MBTA.Model.BadRequestErrorsInner.t]
  }

  alias MBTA.Deserializer

  def decode(value) do
    value
     |> Deserializer.deserialize(:errors, :list, MBTA.Model.BadRequestErrorsInner)
  end
end

