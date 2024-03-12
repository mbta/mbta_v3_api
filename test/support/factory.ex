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

  def raw_route_patterns_with_stops_factory do
    %JsonApi{
      links: %{},
      data: [
        %JsonApi.Item{
          type: "route_pattern",
          id: "Red-3-0",
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
              %JsonApi.Item{
                type: "trip",
                id: "canonical-Red-C1-0",
                attributes: %{
                  "bikes_allowed" => 0,
                  "block_id" => "",
                  "direction_id" => 0,
                  "headsign" => "Braintree",
                  "name" => "",
                  "revenue" => "REVENUE",
                  "wheelchair_accessible" => 1
                },
                relationships: %{
                  "route" => [
                    %JsonApi.Item{
                      type: "route",
                      id: "Red",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "route_pattern" => [
                    %JsonApi.Item{
                      type: "route_pattern",
                      id: "Red-3-0",
                      attributes: %{
                        "canonical" => true,
                        "direction_id" => 0,
                        "name" => "Alewife - Braintree",
                        "sort_order" => 100_100_000,
                        "time_desc" => nil,
                        "typicality" => 1
                      },
                      relationships: %{}
                    }
                  ],
                  "service" => [
                    %JsonApi.Item{
                      type: "service",
                      id: "canonical",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "shape" => [
                    %JsonApi.Item{
                      type: "shape",
                      id: "canonical-933_0009",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "stops" => [
                    %JsonApi.Item{
                      type: "stop",
                      id: "70061",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Alewife - Red Line",
                        "latitude" => 42.396158,
                        "location_type" => 0,
                        "longitude" => -71.139971,
                        "municipality" => "Cambridge",
                        "name" => "Alewife",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Red Line",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-alfcl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70063",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Davis - Red Line - Ashmont/Braintree",
                        "latitude" => 42.39674,
                        "location_type" => 0,
                        "longitude" => -71.121815,
                        "municipality" => "Somerville",
                        "name" => "Davis",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-davis",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70065",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Porter - Red Line - Ashmont/Braintree",
                        "latitude" => 42.3884,
                        "location_type" => 0,
                        "longitude" => -71.119149,
                        "municipality" => "Cambridge",
                        "name" => "Porter",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-portr",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70067",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Harvard - Red Line - Ashmont/Braintree",
                        "latitude" => 42.373362,
                        "location_type" => 0,
                        "longitude" => -71.118956,
                        "municipality" => "Cambridge",
                        "name" => "Harvard",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-harsq",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70069",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Central - Red Line - Ashmont/Braintree",
                        "latitude" => 42.365304,
                        "location_type" => 0,
                        "longitude" => -71.103621,
                        "municipality" => "Cambridge",
                        "name" => "Central",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-cntsq",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70071",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Kendall/MIT - Red Line - Ashmont/Braintree",
                        "latitude" => 42.362355,
                        "location_type" => 0,
                        "longitude" => -71.085605,
                        "municipality" => "Cambridge",
                        "name" => "Kendall/MIT",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-knncl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70073",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Charles/MGH - Red Line - Ashmont/Braintree",
                        "latitude" => 42.361187,
                        "location_type" => 0,
                        "longitude" => -71.071505,
                        "municipality" => "Boston",
                        "name" => "Charles/MGH",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-chmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70075",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Park Street - Red Line - Ashmont/Braintree",
                        "latitude" => 42.356395,
                        "location_type" => 0,
                        "longitude" => -71.062424,
                        "municipality" => "Boston",
                        "name" => "Park Street",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-pktrm",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70077",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Downtown Crossing - Red Line - Ashmont/Braintree",
                        "latitude" => 42.355518,
                        "location_type" => 0,
                        "longitude" => -71.060225,
                        "municipality" => "Boston",
                        "name" => "Downtown Crossing",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-dwnxg",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70079",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "South Station - Red Line - Ashmont/Braintree",
                        "latitude" => 42.352271,
                        "location_type" => 0,
                        "longitude" => -71.055242,
                        "municipality" => "Boston",
                        "name" => "South Station",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-sstat",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70081",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Broadway - Red Line - Ashmont/Braintree",
                        "latitude" => 42.342622,
                        "location_type" => 0,
                        "longitude" => -71.056967,
                        "municipality" => "Boston",
                        "name" => "Broadway",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-brdwy",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70083",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Andrew - Red Line - Ashmont/Braintree",
                        "latitude" => 42.330154,
                        "location_type" => 0,
                        "longitude" => -71.057655,
                        "municipality" => "Boston",
                        "name" => "Andrew",
                        "on_street" => nil,
                        "platform_code" => "1",
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-andrw",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70095",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "JFK/UMass - Red Line - Braintree",
                        "latitude" => 42.320418,
                        "location_type" => 0,
                        "longitude" => -71.052287,
                        "municipality" => "Boston",
                        "name" => "JFK/UMass",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-jfk",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70097",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "North Quincy - Red Line - Braintree",
                        "latitude" => 42.27577,
                        "location_type" => 0,
                        "longitude" => -71.030194,
                        "municipality" => "Quincy",
                        "name" => "North Quincy",
                        "on_street" => nil,
                        "platform_code" => "2",
                        "platform_name" => "Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-nqncy",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70099",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Wollaston - Red Line - Braintree",
                        "latitude" => 42.266762,
                        "location_type" => 0,
                        "longitude" => -71.020542,
                        "municipality" => "Quincy",
                        "name" => "Wollaston",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-wlsta",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70101",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Quincy Center - Red Line - Braintree",
                        "latitude" => 42.251809,
                        "location_type" => 0,
                        "longitude" => -71.005409,
                        "municipality" => "Quincy",
                        "name" => "Quincy Center",
                        "on_street" => nil,
                        "platform_code" => "2",
                        "platform_name" => "Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-qnctr",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70103",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Quincy Adams - Red Line - Braintree",
                        "latitude" => 42.233391,
                        "location_type" => 0,
                        "longitude" => -71.007153,
                        "municipality" => "Quincy",
                        "name" => "Quincy Adams",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-qamnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70105",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Braintree - Red Line",
                        "latitude" => 42.207424,
                        "location_type" => 0,
                        "longitude" => -71.001645,
                        "municipality" => "Braintree",
                        "name" => "Braintree",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Red Line",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-brntn",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ],
            "route" => [
              %JsonApi.Item{
                type: "route",
                id: "Red",
                attributes: nil,
                relationships: nil
              }
            ]
          }
        },
        %JsonApi.Item{
          type: "route_pattern",
          id: "Red-1-0",
          attributes: %{
            "canonical" => true,
            "direction_id" => 0,
            "name" => "Alewife - Ashmont",
            "sort_order" => 100_100_001,
            "time_desc" => nil,
            "typicality" => 1
          },
          relationships: %{
            "representative_trip" => [
              %JsonApi.Item{
                type: "trip",
                id: "canonical-Red-C2-0",
                attributes: %{
                  "bikes_allowed" => 0,
                  "block_id" => "",
                  "direction_id" => 0,
                  "headsign" => "Ashmont",
                  "name" => "",
                  "revenue" => "REVENUE",
                  "wheelchair_accessible" => 1
                },
                relationships: %{
                  "route" => [
                    %JsonApi.Item{
                      type: "route",
                      id: "Red",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "route_pattern" => [
                    %JsonApi.Item{
                      type: "route_pattern",
                      id: "Red-1-0",
                      attributes: %{
                        "canonical" => true,
                        "direction_id" => 0,
                        "name" => "Alewife - Ashmont",
                        "sort_order" => 100_100_001,
                        "time_desc" => nil,
                        "typicality" => 1
                      },
                      relationships: %{}
                    }
                  ],
                  "service" => [
                    %JsonApi.Item{
                      type: "service",
                      id: "canonical",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "shape" => [
                    %JsonApi.Item{
                      type: "shape",
                      id: "canonical-931_0009",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "stops" => [
                    %JsonApi.Item{
                      type: "stop",
                      id: "70061",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Alewife - Red Line",
                        "latitude" => 42.396158,
                        "location_type" => 0,
                        "longitude" => -71.139971,
                        "municipality" => "Cambridge",
                        "name" => "Alewife",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Red Line",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-alfcl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70063",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Davis - Red Line - Ashmont/Braintree",
                        "latitude" => 42.39674,
                        "location_type" => 0,
                        "longitude" => -71.121815,
                        "municipality" => "Somerville",
                        "name" => "Davis",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-davis",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70065",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Porter - Red Line - Ashmont/Braintree",
                        "latitude" => 42.3884,
                        "location_type" => 0,
                        "longitude" => -71.119149,
                        "municipality" => "Cambridge",
                        "name" => "Porter",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-portr",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70067",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Harvard - Red Line - Ashmont/Braintree",
                        "latitude" => 42.373362,
                        "location_type" => 0,
                        "longitude" => -71.118956,
                        "municipality" => "Cambridge",
                        "name" => "Harvard",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-harsq",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70069",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Central - Red Line - Ashmont/Braintree",
                        "latitude" => 42.365304,
                        "location_type" => 0,
                        "longitude" => -71.103621,
                        "municipality" => "Cambridge",
                        "name" => "Central",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-cntsq",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70071",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Kendall/MIT - Red Line - Ashmont/Braintree",
                        "latitude" => 42.362355,
                        "location_type" => 0,
                        "longitude" => -71.085605,
                        "municipality" => "Cambridge",
                        "name" => "Kendall/MIT",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-knncl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70073",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Charles/MGH - Red Line - Ashmont/Braintree",
                        "latitude" => 42.361187,
                        "location_type" => 0,
                        "longitude" => -71.071505,
                        "municipality" => "Boston",
                        "name" => "Charles/MGH",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-chmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70075",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Park Street - Red Line - Ashmont/Braintree",
                        "latitude" => 42.356395,
                        "location_type" => 0,
                        "longitude" => -71.062424,
                        "municipality" => "Boston",
                        "name" => "Park Street",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-pktrm",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70077",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Downtown Crossing - Red Line - Ashmont/Braintree",
                        "latitude" => 42.355518,
                        "location_type" => 0,
                        "longitude" => -71.060225,
                        "municipality" => "Boston",
                        "name" => "Downtown Crossing",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-dwnxg",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70079",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "South Station - Red Line - Ashmont/Braintree",
                        "latitude" => 42.352271,
                        "location_type" => 0,
                        "longitude" => -71.055242,
                        "municipality" => "Boston",
                        "name" => "South Station",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-sstat",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70081",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Broadway - Red Line - Ashmont/Braintree",
                        "latitude" => 42.342622,
                        "location_type" => 0,
                        "longitude" => -71.056967,
                        "municipality" => "Boston",
                        "name" => "Broadway",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-brdwy",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70083",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Andrew - Red Line - Ashmont/Braintree",
                        "latitude" => 42.330154,
                        "location_type" => 0,
                        "longitude" => -71.057655,
                        "municipality" => "Boston",
                        "name" => "Andrew",
                        "on_street" => nil,
                        "platform_code" => "1",
                        "platform_name" => "Ashmont/Braintree",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-andrw",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70085",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "JFK/UMass - Red Line - Ashmont",
                        "latitude" => 42.320632,
                        "location_type" => 0,
                        "longitude" => -71.052514,
                        "municipality" => "Boston",
                        "name" => "JFK/UMass",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-jfk",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70087",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Savin Hill - Red Line - Ashmont",
                        "latitude" => 42.310603,
                        "location_type" => 0,
                        "longitude" => -71.053678,
                        "municipality" => "Boston",
                        "name" => "Savin Hill",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-shmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70089",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Fields Corner - Red Line - Ashmont",
                        "latitude" => 42.299993,
                        "location_type" => 0,
                        "longitude" => -71.062021,
                        "municipality" => "Boston",
                        "name" => "Fields Corner",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-fldcr",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70091",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Shawmut - Red Line - Ashmont",
                        "latitude" => 42.293126,
                        "location_type" => 0,
                        "longitude" => -71.065738,
                        "municipality" => "Boston",
                        "name" => "Shawmut",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-smmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70093",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Ashmont - Red Line - Exit Only",
                        "latitude" => 42.284508,
                        "location_type" => 0,
                        "longitude" => -71.063833,
                        "municipality" => "Boston",
                        "name" => "Ashmont",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Exit Only",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-asmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ],
            "route" => [
              %JsonApi.Item{
                type: "route",
                id: "Red",
                attributes: nil,
                relationships: nil
              }
            ]
          }
        },
        %JsonApi.Item{
          type: "route_pattern",
          id: "Red-A-0",
          attributes: %{
            "canonical" => false,
            "direction_id" => 0,
            "name" => "JFK/UMass - Ashmont",
            "sort_order" => 100_100_130,
            "time_desc" => "Weekends only",
            "typicality" => 3
          },
          relationships: %{
            "representative_trip" => [
              %JsonApi.Item{
                type: "trip",
                id: "61203187",
                attributes: %{
                  "bikes_allowed" => 0,
                  "block_id" => "S2832-11",
                  "direction_id" => 0,
                  "headsign" => "Ashmont",
                  "name" => "",
                  "revenue" => "REVENUE",
                  "wheelchair_accessible" => 1
                },
                relationships: %{
                  "route" => [
                    %JsonApi.Item{
                      type: "route",
                      id: "Red",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "route_pattern" => [
                    %JsonApi.Item{
                      type: "route_pattern",
                      id: "Red-A-0",
                      attributes: %{
                        "canonical" => false,
                        "direction_id" => 0,
                        "name" => "JFK/UMass - Ashmont",
                        "sort_order" => 100_100_130,
                        "time_desc" => "Weekends only",
                        "typicality" => 3
                      },
                      relationships: %{}
                    }
                  ],
                  "service" => [
                    %JsonApi.Item{
                      type: "service",
                      id: "RTL12024-hms14pj6-Saturday-01",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "shape" => [
                    %JsonApi.Item{
                      type: "shape",
                      id: "28320002",
                      attributes: nil,
                      relationships: nil
                    }
                  ],
                  "stops" => [
                    %JsonApi.Item{
                      type: "stop",
                      id: "70085",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "JFK/UMass - Red Line - Ashmont",
                        "latitude" => 42.320632,
                        "location_type" => 0,
                        "longitude" => -71.052514,
                        "municipality" => "Boston",
                        "name" => "JFK/UMass",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-jfk",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70087",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Savin Hill - Red Line - Ashmont",
                        "latitude" => 42.310603,
                        "location_type" => 0,
                        "longitude" => -71.053678,
                        "municipality" => "Boston",
                        "name" => "Savin Hill",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-shmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70089",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Fields Corner - Red Line - Ashmont",
                        "latitude" => 42.299993,
                        "location_type" => 0,
                        "longitude" => -71.062021,
                        "municipality" => "Boston",
                        "name" => "Fields Corner",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-fldcr",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70091",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Shawmut - Red Line - Ashmont",
                        "latitude" => 42.293126,
                        "location_type" => 0,
                        "longitude" => -71.065738,
                        "municipality" => "Boston",
                        "name" => "Shawmut",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Ashmont",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-smmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    },
                    %JsonApi.Item{
                      type: "stop",
                      id: "70093",
                      attributes: %{
                        "address" => nil,
                        "at_street" => nil,
                        "description" => "Ashmont - Red Line - Exit Only",
                        "latitude" => 42.284508,
                        "location_type" => 0,
                        "longitude" => -71.063833,
                        "municipality" => "Boston",
                        "name" => "Ashmont",
                        "on_street" => nil,
                        "platform_code" => nil,
                        "platform_name" => "Exit Only",
                        "vehicle_type" => 1,
                        "wheelchair_boarding" => 1
                      },
                      relationships: %{
                        "facilities" => [],
                        "parent_station" => [
                          %JsonApi.Item{
                            type: "stop",
                            id: "place-asmnl",
                            attributes: nil,
                            relationships: nil
                          }
                        ],
                        "zone" => [
                          %JsonApi.Item{
                            type: "zone",
                            id: "RapidTransit",
                            attributes: nil,
                            relationships: nil
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ],
            "route" => [
              %JsonApi.Item{
                type: "route",
                id: "Red",
                attributes: nil,
                relationships: nil
              }
            ]
          }
        }
      ]
    }
  end
end
