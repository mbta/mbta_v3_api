defmodule MBTAV3API.Facilities.Repo do
  @moduledoc """
  Repo to get facilitiy information.
  """
  use RepoCache, ttl: :timer.hours(1)

  alias MBTAV3API.Facilities
  alias MBTAV3API.Facilities.Facility

  @spec all(keyword(), keyword()) :: [Facility.t()]
  def all(params \\ [], opts \\ []) do
    cache({params, opts}, fn {params, opts} ->
      with %{data: facilities} <- MBTAV3API.Facilities.all(params, opts) do
        {:ok, facilities}
      end
    end)
    |> cache_facilities_result
  end

  def get(id, params \\ [], opts \\ []) when is_binary(id) do
    cache({id, params, opts}, fn {id, params, opts} ->
      with %{data: [facility]} <- Facilities.get(id, params, opts) do
        {:ok, facility}
      end
    end)
    |> cache_facility_result
  end

  defp cache_facility_result({:ok, facility}), do: Facility.parse(facility)
  defp cache_facility_result({:error, _}), do: nil

  def get_for_stop(stop_id, opts \\ []) do
    facilities_filter_by_fn =
      Keyword.get(opts, :facilities_filter_by_fn, &Facilities.filter_by/1)

    cache(stop_id, fn stop_id ->
      facilities_filter_by_fn.([{"stop", stop_id}])
    end)
  end

  def get_by_type(type, opts \\ [])

  def get_by_type(type, opts) when is_list(type) do
    type |> Enum.join(",") |> get_by_type(opts)
  end

  def get_by_type(type, opts) do
    cache(type, fn type ->
      with %{data: facilities} <- MBTAV3API.Facilities.filter_by([{"type", type}], opts) do
        {:ok, facilities}
      end
    end)
    |> cache_facilities_result
  end

  defp cache_facilities_result({:ok, facilities}), do: Enum.map(facilities, &Facility.parse/1)
  defp cache_facilities_result({:error, _}), do: nil
end
