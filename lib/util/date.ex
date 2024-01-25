defmodule Util.Date do
  @moduledoc """
  Service-related utilities.
  """

  alias Timex.{AmbiguousDateTime, Timezone}

  @local_tz "America/New_York"

  @doc "The current datetime in the America/New_York timezone."
  @spec now() :: DateTime.t()
  @spec now((String.t() -> DateTime.t())) :: DateTime.t()
  def now(utc_now_fn \\ &Timex.now/1) do
    @local_tz
    |> utc_now_fn.()
    |> to_local_time()
  end

  @doc "Converts a DateTime.t into the America/New_York zone, handling ambiguities"
  @spec to_local_time(DateTime.t() | NaiveDateTime.t() | AmbiguousDateTime.t()) ::
          DateTime.t() | {:error, any}
  def to_local_time(%DateTime{zone_abbr: zone} = time)
      when zone in ["EDT", "EST", "-04", "-05"] do
    time
  end

  def to_local_time(%DateTime{zone_abbr: "UTC"} = time) do
    time
    |> Timezone.convert(@local_tz)
    |> handle_ambiguous_time()
  end

  # important: assumes the NaiveDateTime is in UTC.
  def to_local_time(%NaiveDateTime{} = time) do
    time
    |> DateTime.from_naive!("Etc/UTC")
    |> to_local_time()
  end

  def to_local_time(%AmbiguousDateTime{} = time), do: handle_ambiguous_time(time)

  @doc """

  The current service date.  The service date lasts from 3am to 2:59am, so
  times after midnight belong to the service of the previous date.

  """
  @spec service_date(DateTime.t() | NaiveDateTime.t()) :: Date.t()
  def service_date(current_time \\ now()) do
    current_time
    |> to_local_time()
    |> do_service_date()
  end

  defp do_service_date(%DateTime{hour: hour} = time) when hour < 3 do
    time
    |> Timex.shift(hours: -3)
    |> DateTime.to_date()
  end

  defp do_service_date(%DateTime{} = time) do
    DateTime.to_date(time)
  end

  @spec handle_ambiguous_time(AmbiguousDateTime.t() | DateTime.t() | {:error, any}) ::
          DateTime.t() | {:error, any}
  defp handle_ambiguous_time(%AmbiguousDateTime{before: before}) do
    # ambiguous time only happens between midnight and 3am
    # during November daylight saving transition
    before
  end

  defp handle_ambiguous_time(%DateTime{} = time) do
    time
  end

  defp handle_ambiguous_time({:error, error}) do
    {:error, error}
  end
end
