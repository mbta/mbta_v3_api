defmodule MBTAV3API.Support.Factory do
  @moduledoc """
  ExMachina factory definitions for generating test data.
  """

  use ExMachina

  alias JsonApi.Item

  def stop_data_factory do
    %Item{
      id: "place-NHRML-0127",
      type: "stop",
      attributes: %{
        "address" => "100 Atlantic Ave, Woburn, MA 01801",
        "description" => nil,
        "latitude" => 42.516987,
        "location_type" => 1,
        "longitude" => -71.144475,
        "municipality" => "Woburn",
        "name" => "Anderson/Woburn",
        "platform_code" => nil,
        "platform_name" => nil,
        "wheelchair_boarding" => 1
      },
      relationships: %{
        "child_stops" => [
          %Item{
            attributes: %{
              "address" => nil,
              "description" => "Anderson/Woburn - Commuter Rail - Track 2 (Boston)",
              "latitude" => 42.516987,
              "location_type" => 0,
              "longitude" => -71.144475,
              "municipality" => "Woburn",
              "name" => "Anderson/Woburn",
              "platform_code" => "2",
              "platform_name" => "Track 2 (Boston)",
              "wheelchair_boarding" => 1
            },
            id: "NHRML-0127-02",
            relationships: %{
              "facilities" => [],
              "parent_station" => [
                %Item{
                  attributes: %{
                    "address" => "100 Atlantic Ave, Woburn, MA 01801",
                    "description" => nil,
                    "latitude" => 42.516987,
                    "location_type" => 1,
                    "longitude" => -71.144475,
                    "municipality" => "Woburn",
                    "name" => "Anderson/Woburn",
                    "platform_code" => nil,
                    "platform_name" => nil,
                    "wheelchair_boarding" => 1
                  },
                  id: "place-NHRML-0127",
                  relationships: %{},
                  type: "stop"
                }
              ],
              "zone" => [
                %Item{
                  attributes: nil,
                  id: "CR-zone-2",
                  relationships: nil,
                  type: "zone"
                }
              ]
            },
            type: "stop"
          }
        ],
        "facilities" => [
          %Item{
            attributes: %{
              "latitude" => 42.518544,
              "long_name" => "Anderson/Woburn Park and Ride Parking Lot",
              "longitude" => -71.144061,
              "properties" => [
                %{"name" => "attended", "value" => 1},
                %{"name" => "capacity", "value" => 1200},
                %{"name" => "contact", "value" => "Massport"},
                %{"name" => "contact-phone", "value" => "781-721-0373"},
                %{
                  "name" => "contact-url",
                  "value" =>
                    "https://www.lazparking.com/local/woburn-ma/anderson-regional-transportation-center"
                },
                %{"name" => "enclosed", "value" => 2},
                %{"name" => "fee-daily", "value" => "$4"},
                %{"name" => "fee-monthly", "value" => "$70"},
                %{"name" => "municipality", "value" => "Woburn"},
                %{
                  "name" => "note",
                  "value" =>
                    "Massport is responsible for parking maintenance, payments, and snow removal."
                },
                %{"name" => "operator", "value" => "LAZ Parking"},
                %{"name" => "owner", "value" => "Local transit authority"},
                %{"name" => "payment-form-accepted", "value" => "cash"},
                %{
                  "name" => "payment-form-accepted",
                  "value" => "credit-debit-card"
                }
              ],
              "type" => "PARKING_AREA"
            },
            id: "park-NHRML-0127-parkride",
            relationships: %{
              "stop" => [
                %Item{
                  attributes: %{
                    "address" => "100 Atlantic Ave, Woburn, MA 01801",
                    "description" => nil,
                    "latitude" => 42.516987,
                    "location_type" => 1,
                    "longitude" => -71.144475,
                    "municipality" => "Woburn",
                    "name" => "Anderson/Woburn",
                    "platform_code" => nil,
                    "platform_name" => nil,
                    "wheelchair_boarding" => 1
                  },
                  id: "place-NHRML-0127",
                  relationships: %{},
                  type: "stop"
                }
              ]
            },
            type: "facility"
          },
          %Item{
            attributes: %{
              "latitude" => 42.517377,
              "long_name" => "Anderson/Woburn fare vending machine 202213",
              "longitude" => -71.144055,
              "properties" => [
                %{"name" => "enclosed", "value" => 1},
                %{
                  "name" => "payment-form-accepted",
                  "value" => "credit-debit-card"
                }
              ],
              "type" => "FARE_VENDING_MACHINE"
            },
            id: "fvm-202213",
            relationships: %{
              "stop" => [
                %Item{
                  attributes: %{
                    "address" => "100 Atlantic Ave, Woburn, MA 01801",
                    "description" => nil,
                    "latitude" => 42.516987,
                    "location_type" => 1,
                    "longitude" => -71.144475,
                    "municipality" => "Woburn",
                    "name" => "Anderson/Woburn",
                    "platform_code" => nil,
                    "platform_name" => nil,
                    "wheelchair_boarding" => 1
                  },
                  id: "place-NHRML-0127",
                  relationships: %{},
                  type: "stop"
                }
              ]
            },
            type: "facility"
          }
        ],
        "parent_station" => [],
        "zone" => [
          %Item{
            attributes: nil,
            id: "CR-zone-2",
            relationships: nil,
            type: "zone"
          }
        ]
      }
    }
  end

  def child_stop_data_factory do
    %JsonApi.Item{
      id: "NHRML-0127-02",
      type: "stop",
      attributes: %{
        "address" => nil,
        "description" => "Anderson/Woburn - Commuter Rail - Track 2 (Boston)",
        "latitude" => 42.516987,
        "location_type" => 0,
        "longitude" => -71.144475,
        "municipality" => "Woburn",
        "name" => "Anderson/Woburn",
        "platform_code" => "2",
        "platform_name" => "Track 2 (Boston)",
        "wheelchair_boarding" => 1
      },
      relationships: %{
        "child_stops" => [],
        "facilities" => [],
        "parent_station" => [
          %JsonApi.Item{
            attributes: %{
              "address" => "100 Atlantic Ave, Woburn, MA 01801",
              "description" => nil,
              "latitude" => 42.516987,
              "location_type" => 1,
              "longitude" => -71.144475,
              "municipality" => "Woburn",
              "name" => "Anderson/Woburn",
              "platform_code" => nil,
              "platform_name" => nil,
              "wheelchair_boarding" => 1
            },
            id: "place-NHRML-0127",
            relationships: %{
              "facilities" => [],
              "parent_station" => [],
              "zone" => [
                %JsonApi.Item{
                  attributes: nil,
                  id: "CR-zone-2",
                  relationships: nil,
                  type: "zone"
                }
              ]
            },
            type: "stop"
          }
        ],
        "zone" => [
          %JsonApi.Item{
            attributes: nil,
            id: "CR-zone-2",
            relationships: nil,
            type: "zone"
          }
        ]
      }
    }
  end

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

  def schedule_data_factory do
    %Item{
      id: "31174458-CR_MAY2016-hxl16011-Weekday-01-Lowell-schedule",
      type: "schedule",
      attributes: %{
        "departure_time" => "2016-06-08T05:35:00-04:00",
        "pickup_type" => 3,
        "drop_off_type" => 1,
        "timepoint" => false
      },
      relationships: %{
        "stop" => [
          %Item{
            attributes: %{
              "name" => "Lowell"
            },
            id: "Lowell",
            relationships: %{"parent_station" => []},
            type: "stop"
          }
        ],
        "trip" => [
          %Item{
            attributes: %{
              "headsign" => "North Station",
              "name" => "300",
              "direction_id" => 1
            },
            id: "31174458-CR_MAY2016-hxl16011-Weekday-01",
            relationships: %{"predictions" => [], "service" => [], "vehicle" => []},
            type: "trip"
          }
        ],
        "route" => [
          %Item{
            id: "CR-Lowell",
            type: "route",
            attributes: %{
              "long_name" => "Lowell Line",
              "direction_names" => ["Outbound", "Inbound"],
              "type" => 2
            },
            relationships: %{}
          }
        ]
      }
    }
  end
end
