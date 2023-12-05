# NOTE: This file is auto generated by OpenAPI Generator 7.1.0 (https://openapi-generator.tech).
# Do not edit this file manually.

defmodule MBTA.Model.RouteResourceAttributes do
  @moduledoc """
  
  """

  @derive Jason.Encoder
  defstruct [
    :type,
    :text_color,
    :sort_order,
    :short_name,
    :long_name,
    :fare_class,
    :direction_names,
    :direction_destinations,
    :description,
    :color
  ]

  @type t :: %__MODULE__{
    :type => integer() | nil,
    :text_color => String.t | nil,
    :sort_order => integer() | nil,
    :short_name => String.t | nil,
    :long_name => String.t | nil,
    :fare_class => String.t | nil,
    :direction_names => [String.t] | nil,
    :direction_destinations => [String.t] | nil,
    :description => String.t | nil,
    :color => String.t | nil
  }

  def decode(value) do
    value
  end
end

