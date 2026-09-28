defmodule MBTAV3API.Stops.Helpers do
  @moduledoc """
  Helpers forworking with stop-related data structs.
  """
  alias MBTAV3API.Stops.Stop.ParkingLot.{Capacity, Manager, Payment, Utilization}
  alias MBTAV3API.Stops.Stop.ParkingLot.Payment.MobileApp

  @nil_structs [
    %Capacity{},
    %Manager{},
    %Payment{},
    %Utilization{},
    %MobileApp{}
  ]

  def struct_or_nil(struct) when struct in @nil_structs, do: nil
  def struct_or_nil(struct), do: struct
end
