defmodule MBTAV3API.Lines.Repo do
  @moduledoc "Repo for fetching Line resources and their associated data from the MBTA V3 API."

  use RepoCache, ttl: :timer.hours(1)
  alias JsonApi
  alias MBTAV3API.Lines
  alias MBTAV3API.Lines.Line
  alias MBTAV3API.Lines.Parser

  @default_opts [include: "routes"]

  def all(opts \\ []) do
    opts = @default_opts ++ opts

    cache(opts, fn _ ->
      result = handle_response(Lines.all(@default_opts))

      for {:ok, lines} <- [result],
          line <- lines do
        ConCache.put(__MODULE__, {:get, line.id}, {:ok, line})
      end

      result
    end)
    |> cache_lines_result
  end

  defp cache_lines_result({:ok, lines}), do: lines
  defp cache_lines_result({:error, _}), do: []

  def get(id, opts \\ []) when is_binary(id) do
    opts = @default_opts ++ opts

    cache({id, opts}, fn {id, opts} ->
      with %{data: [line]} <- Lines.get(id, opts) do
        {:ok, line}
      end
    end)
    |> cache_line_result
  end

  defp cache_line_result({:ok, line}), do: Parser.parse_line(line)
  defp cache_line_result({:error, _}), do: nil

  @doc """
  Parses json into a list of lines, or an error if it happened.
  """
  @spec handle_response(JsonApi.t() | {:error, any}) :: {:ok, [Line.t()]} | {:error, any}
  def handle_response({:error, reason}) do
    {:error, reason}
  end

  def handle_response(%{data: data}) do
    {:ok,
     data
     |> Enum.map(&Parser.parse_line/1)
     |> Enum.uniq()
     |> Enum.sort_by(& &1.sort_order)}
  end
end
