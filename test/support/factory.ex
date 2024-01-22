defmodule MBTAV3API.Support.Factory do
  @moduledoc """
  ExMachina factory definitions for generating test data.
  """

  use ExMachina

  alias JsonApi.Item

  def route_pattern_data_factory do
    %Item{
      id: "111-5-0",
      type: "route_pattern",
      attributes: %{
        "canonical" => false,
        "direction_id" => 0,
        "name" => "Haymarket Station - Woodlawn",
        "sort_order" => 511_100_000,
        "time_desc" => nil,
        "typicality" => 1
      },
      relationships: %{
        "representative_trip" => [
          %Item{
            id: "60311384",
            type: "trip"
          }
        ],
        "route" => [
          %Item{
            id: "111",
            type: "route"
          }
        ]
      }
    }
  end

  def route_pattern_with_shapes_and_stops_data_factory do
    %Item{
      id: "Red-3-0",
      type: "route_pattern",
      attributes: %{
        "canonical" => true,
        "direction_id" => 0,
        "name" => "Alewife - Braintree",
        "sort_order" => 100_100_000,
        "time_desc" => nil,
        "typicality" => 1
      },
      relationships: %{
        "representative_trip" => [
          %Item{
            id: "canonical-Red-C1-0",
            type: "trip",
            attributes: %{
              "direction_id" => 0,
              "headsign" => "Braintree"
            },
            relationships: %{
              "route" => [
                %Item{
                  attributes: nil,
                  id: "Red",
                  relationships: nil,
                  type: "route"
                }
              ],
              "route_pattern" => [
                %Item{
                  attributes: %{
                    "canonical" => true,
                    "direction_id" => 0,
                    "name" => "Alewife - Braintree",
                    "sort_order" => 100_100_000,
                    "time_desc" => nil,
                    "typicality" => 1
                  },
                  id: "Red-3-0",
                  relationships: %{},
                  type: "route_pattern"
                }
              ],
              "service" => [
                %Item{
                  attributes: nil,
                  id: "canonical",
                  relationships: nil,
                  type: "service"
                }
              ],
              "shape" => [
                %Item{
                  id: "canonical-933_0009",
                  type: "shape",
                  attributes: %{
                    "direction_id" => 0,
                    "name" => "Alewife - Braintree",
                    "polyline" =>
                      "}nwaG~|eqLGyNIqAAc@S_CAEWu@g@}@u@k@u@Wu@OMGIMISQkAOcAGw@SoDFkCf@sUXcJJuERwHPkENqCJmB^mDn@}D??D[TeANy@\\iAt@qB`AwBl@cAl@m@b@Yn@QrBEtCKxQ_ApMT??R?`m@hD`Np@jAF|@C`B_@hBi@n@s@d@gA`@}@Z_@RMZIl@@fBFlB\\tAP??~@L^?HCLKJWJ_@vC{NDGLQvG}HdCiD`@e@Xc@b@oAjEcPrBeGfAsCvMqVl@sA??jByD`DoGd@cAj@cBJkAHqBNiGXeHVmJr@kR~@q^HsB@U??NgDr@gJTcH`@aMFyCF}AL}DN}GL}CXkILaD@QFmA@[??DaAFiBDu@BkA@UB]Fc@Jo@BGJ_@Lc@\\}@vJ_OrCyDj@iAb@_AvBuF`@gA`@aAv@qBVo@Xu@??bDgI??Tm@~IsQj@cAr@wBp@kBj@kB??HWtDcN`@g@POl@UhASh@Eb@?t@FXHl@Px@b@he@h[pCC??bnAm@h@T??xF|BpBp@^PLBXAz@Yl@]l@e@|B}CT[p@iA|A}BZi@jBeDnAiBz@iAf@k@l@g@dAs@fAe@|@WpCe@l@GTCRE\\G??~@O`@ELA|AGf@A\\CjCGrEKz@AdEAxHY|BD~@JjB^fF~AdDbA|InCxCv@zD|@rWfEXDpB`@tANvAHx@AjBIx@M~@S~@a@fAi@HEnA{@fA{@|HuI|DwEbDqDpLkNhCyClEiFhLaN`@c@f@o@RURUbDsDbAiA`AgAv@_AHKHI~E}FdBoBfAgAfD{DxDoE~DcF|BkClAwALODEJOJK|@gATWvAoA`Au@fAs@hAk@n@QpAa@vDeAhA[x@Yh@Wv@a@b@YfAaAjCgCz@aAtByBz@{@??|FaGtCaDbL{LhI{IzHgJdAuAjC{CVYvAwA??JIl@a@NMNM\\[|AuArF_GlPyQrD_ErAwAd@e@nE{ErDuD\\a@nE_FZYPSRUvL{Mv@}@Z[JILKv@m@z@i@fCkAlBmAl@[t@[??h@WxBeAp@]dAi@p@YXIPEXKDALENEbAQl@Gz@ChADtAL~ARnCZbGx@xB`@TDL@PBzAVjIvA^FVDVB|@NjHlAlPnCnCd@vBXhBNv@JtAPL@|BXrAN??`@FRBj@Bp@FbADz@?dAIp@I|@Mx@Q`AWhAYlBs@pDaBzAs@nBgAZQJGJGhAs@RKVMNKTMf@YdHcEzBmApAw@`GmDLI@AHGlEwClAi@hA_@v@Up@ObB]z@Kr@Ir@EZCpA?dCRf@DpAHvANrE`@bDTr@DfMdA`CJvBRn@DnCLnBPfAFV@",
                    "priority" => -1
                  },
                  relationships: %{
                    "route" => [
                      %Item{
                        attributes: nil,
                        id: "Red",
                        relationships: nil,
                        type: "route"
                      }
                    ],
                    "stops" => [
                      %Item{
                        attributes: nil,
                        id: "place-sstat",
                        relationships: nil,
                        type: "stop"
                      }
                    ]
                  }
                }
              ],
              "stops" => [
                %Item{
                  id: "70079",
                  type: "stop",
                  attributes: %{
                    "name" => "South Station",
                    "location_type" => 0,
                    "latitude" => 42.352271,
                    "longitude" => -71.055242,
                    "platform_name" => "Ashmont/Braintree",
                    "vehicle_type" => 1
                  },
                  relationships: %{
                    "facilities" => [],
                    "parent_station" => [
                      %Item{
                        attributes: nil,
                        id: "place-sstat",
                        relationships: nil,
                        type: "stop"
                      }
                    ],
                    "zone" => [
                      %Item{
                        attributes: nil,
                        id: "RapidTransit",
                        relationships: nil,
                        type: "zone"
                      }
                    ]
                  }
                }
              ]
            }
          }
        ],
        "route" => [
          %Item{
            attributes: nil,
            id: "Red",
            relationships: nil,
            type: "route"
          }
        ]
      }
    }
  end
end
