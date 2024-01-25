defmodule Util.DateTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Timex.AmbiguousDateTime
  alias Util.Date, as: DateUtil

  setup_all do
    Application.put_env(:elixir, :time_zone_database, Tzdata.TimeZoneDatabase)
  end

  describe "now/0" do
    test "returns a DateTime" do
      assert %DateTime{} = DateUtil.now()
    end
  end

  describe "to_local_time/1" do
    test "handles NaiveDateTime" do
      assert %DateTime{day: 02, hour: 0, zone_abbr: "EST"} =
               DateUtil.to_local_time(~N[2016-01-02T05:00:00])
    end

    test "handles NaiveDateTime in EST -> EDT transition" do
      assert %DateTime{month: 3, day: 11, hour: 1, zone_abbr: "EST"} =
               DateUtil.to_local_time(~N[2018-03-11T06:00:00])

      assert %DateTime{month: 3, day: 11, hour: 3, zone_abbr: "EDT"} =
               DateUtil.to_local_time(~N[2018-03-11T07:00:00])
    end

    test "handles DateTime in UTC timezone" do
      assert %DateTime{day: 02, hour: 0} =
               ~N[2016-01-02T05:00:00]
               |> DateTime.from_naive!("Etc/UTC")
               |> DateUtil.to_local_time()
    end

    test "handles Timex.AmbiguousDateTime.t" do
      before_date = DateUtil.to_local_time(~N[2018-11-04T05:00:00])
      after_date = DateUtil.to_local_time(~N[2018-11-04T06:00:00])

      assert before_date ==
               DateUtil.to_local_time(%AmbiguousDateTime{after: after_date, before: before_date})
    end
  end

  describe "service_date/0" do
    test "returns the service date for the current time" do
      assert DateUtil.service_date() == DateUtil.service_date(DateUtil.now())
    end
  end

  describe "service_date/1 for NaiveDateTime" do
    test "returns the service date" do
      yesterday = ~D[2016-01-01]
      today = ~D[2016-01-02]

      midnight = ~N[2016-01-02T05:00:00]
      assert %DateTime{day: 02, hour: 0} = DateUtil.to_local_time(midnight)
      assert DateUtil.service_date(midnight) == yesterday

      one_am = ~N[2016-01-02T06:00:00]
      assert %DateTime{day: 02, hour: 1} = DateUtil.to_local_time(one_am)
      assert DateUtil.service_date(one_am) == yesterday

      two_am = ~N[2016-01-02T07:00:00]
      assert %DateTime{day: 02, hour: 2} = DateUtil.to_local_time(two_am)
      assert DateUtil.service_date(two_am) == yesterday

      three_am = ~N[2016-01-02T08:00:00]
      assert %DateTime{day: 02, hour: 3} = DateUtil.to_local_time(three_am)
      assert DateUtil.service_date(three_am) == today

      four_am = ~N[2016-01-02T09:00:00]
      assert %DateTime{day: 02, hour: 4} = DateUtil.to_local_time(four_am)
      assert DateUtil.service_date(four_am) == today
    end

    test "handles EST -> EDT transition" do
      # midnight EST
      assert DateUtil.service_date(~N[2018-03-11T05:00:00]) == ~D[2018-03-10]
      # 1am EST
      assert DateUtil.service_date(~N[2018-03-11T06:00:00]) == ~D[2018-03-10]
      # 2am EST / 3am EDT
      assert DateUtil.service_date(~N[2018-03-11T07:00:00]) == ~D[2018-03-11]
      # 4am EDT
      assert DateUtil.service_date(~N[2018-03-11T08:00:00]) == ~D[2018-03-11]
    end
  end

  describe "service_date/1 for DateTime in America/New_York timezone" do
    test "returns the service date" do
      yesterday = ~D[2016-01-01]
      today = ~D[2016-01-02]

      # 12am
      assert ~N[2016-01-02T05:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == yesterday

      # 1am
      assert ~N[2016-01-02T06:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == yesterday

      # 2am
      assert ~N[2016-01-02T07:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == yesterday

      # 3am
      assert ~N[2016-01-02T08:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == today

      # 4am
      assert ~N[2016-01-02T09:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == today
    end

    test "handles EST -> EDT transition" do
      # midnight EST
      assert ~N[2018-03-11T05:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == ~D[2018-03-10]

      # 1am EST
      assert ~N[2018-03-11T06:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == ~D[2018-03-10]

      # 2am EST / 3am EDT
      assert ~N[2018-03-11T07:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == ~D[2018-03-11]

      # 4am EDT
      assert ~N[2018-03-11T08:00:00]
             |> DateUtil.to_local_time()
             |> DateUtil.service_date() == ~D[2018-03-11]
    end
  end

  describe "service_date/1 for DateTime in UTC timezone" do
    test "returns the service date" do
      yesterday = ~D[2016-01-01]
      today = ~D[2016-01-02]

      # 12am
      assert ~N[2016-01-02T05:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == yesterday

      # 1am
      assert ~N[2016-01-02T06:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == yesterday

      # 2am
      assert ~N[2016-01-02T07:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == yesterday

      # 3am
      assert ~N[2016-01-02T08:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == today

      # 4am
      assert ~N[2016-01-02T09:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == today
    end

    test "handles EST -> EDT transition" do
      # midnight EST
      assert ~N[2018-03-11T05:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == ~D[2018-03-10]

      # 1am EST
      assert ~N[2018-03-11T06:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == ~D[2018-03-10]

      # 2am EST / 3am EDT
      assert ~N[2018-03-11T07:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == ~D[2018-03-11]

      # 4am EDT
      assert ~N[2018-03-11T08:00:00]
             |> DateTime.from_naive!("Etc/UTC")
             |> DateUtil.service_date() == ~D[2018-03-11]
    end
  end
end
