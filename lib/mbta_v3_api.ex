defmodule MBTAV3API do
  @moduledoc """
  Documentation for `MBTAV3API`.
  """
  alias MBTAV3API.JSONAPI

  @doc """
  Get all objects matching the given query.

  Supports a very specific subset of the Ecto Query DSL:

  - `from`
  - `where`
  """
  def all(query) do
    opts = to_req_opts(query)

    %Req.Response{status: 200, body: %{} = resp_body} =
      Req.get!(req(), opts)

    resp_jsonapi = JSONAPI.parse!(resp_body)

    JSONAPI.decode!(resp_jsonapi)
  end

  @doc """
  Get an object by its ID.

  ## Examples

      iex> MBTAV3API.get!(MBTAV3API.Stop, "place-boyls")
      %MBTAV3API.Stop{
        id: "place-boyls",
        address: "Boylston St and Tremont St, Boston, MA",
        latitude: 42.35302,
        location_type: :station,
        longitude: -71.06459,
        municipality: "Boston",
        name: "Boylston",
        wheelchair_boarding: :inaccessible
      }

  """
  def get!(obj, id, opts \\ []) do
    include =
      case Keyword.get(opts, :include) do
        nil ->
          nil

        include ->
          validate_include(obj, include)
          JSONAPI.include(include)
      end

    %Req.Response{status: 200, body: %{} = resp_body} =
      Req.get!(req(),
        url:
          case obj do
            MBTAV3API.Alert -> "/alerts/:id"
            MBTAV3API.Facility -> "/facilities/:id"
            MBTAV3API.Stop -> "/stops/:id"
          end,
        params: [include: include] |> Keyword.reject(fn {_, v} -> is_nil(v) end),
        path_params: [id: id]
      )

    resp_jsonapi = JSONAPI.parse!(resp_body)

    JSONAPI.decode!(resp_jsonapi)
  end

  @doc """
  Connect to a [stream](https://www.mbta.com/developers/v3-api/streaming) and emit reset/add/update/remove events.

  Supports the same arguments as `all/1`.

  Probably best run in a separate `Task`.
  """
  @spec stream(Ecto.Queryable.t()) ::
          Enumerable.t({:reset, [term()]} | {:add | :update | :remove, term()})
  def stream(query) do
    # TODO consider not this
    sses_adapter = fn request ->
      url = URI.to_string(request.url)

      headers =
        Enum.flat_map(request.headers, fn {key, vals} ->
          Enum.map(vals, fn val -> {key, val} end)
        end)

      {:ok, pid} = ServerSentEventStage.start_link(url: url, headers: headers)

      {request, %Req.Response{body: pid}}
    end

    opts =
      to_req_opts(query)
      |> Keyword.merge(headers: [accept: "text/event-stream"], plug: nil, adapter: sses_adapter)

    %Req.Response{body: pid} = Req.get!(req(), opts)

    GenStage.stream([pid])
    |> Stream.map(fn %ServerSentEventStage.Event{event: event, data: data} ->
      data = data |> Jason.decode!() |> then(&JSONAPI.parse!(%{"data" => &1}))

      case event do
        "reset" -> {:reset, data |> JSONAPI.decode!()}
        "add" -> {:add, data |> JSONAPI.decode!()}
        "update" -> {:update, data |> JSONAPI.decode!()}
        "remove" -> {:remove, data}
      end
    end)
  end

  # Used for testing to mock out all API calls (should be nil)
  @req_plug Application.compile_env(:mbta_v3_api, :req_plug)

  defp req do
    Req.new(
      base_url: Application.get_env(:mbta_v3_api, :api_url, "https://api-v3.mbta.com"),
      headers:
        [accept: "application/vnd.api+json"] ++
          if api_key = Application.get_env(:mbta_v3_api, :api_key) do
            ["x-api-key": api_key]
          else
            []
          end,
      plug: @req_plug
    )
  end

  @spec validate_include(module(), JSONAPI.include_arg()) :: :ok
  defp validate_include(schema, included) do
    include_list = List.wrap(included)

    for included <- include_list do
      {rel, subrel} =
        case included do
          rel when is_atom(rel) -> {rel, nil}
          {rel, subrel} -> {rel, subrel}
        end

      case schema.__schema__(:association, rel) do
        nil ->
          schema_name = schema |> Atom.to_string() |> String.replace_prefix("Elixir.", "")
          raise "Can't include #{rel} on #{schema_name}"

        %_{related: subschema} ->
          unless is_nil(subrel) do
            validate_include(subschema, subrel)
          end
      end
    end

    :ok
  end

  defp to_req_opts(query) do
    query = Ecto.Queryable.to_query(query)

    %Ecto.Query{
      aliases: aliases,
      assocs: [],
      combinations: [],
      distinct: nil,
      from: from,
      group_bys: [],
      havings: [],
      joins: [],
      limit: nil,
      lock: nil,
      offset: nil,
      order_bys: [],
      prefix: nil,
      preloads: [],
      select: nil,
      sources: nil,
      updates: [],
      wheres: wheres,
      windows: [],
      with_ctes: nil
    } = query

    0 = map_size(aliases)

    {nil, schema} = from.source

    filter_params =
      wheres
      |> Enum.map(fn
        %Ecto.Query.BooleanExpr{
          op: :and,
          expr:
            {:==, _,
             [
               {{:., _, [{:&, [], [0]}, field_name]}, _, _},
               %Ecto.Query.Tagged{value: field_value}
             ]}
        } ->
          # TODO introduce rigor
          field_name =
            case {schema, field_name} do
              {MBTAV3API.Prediction, :stop_id} -> "stop"
              _ -> field_name
            end

          {"filter[#{field_name}]", field_value}
      end)

    [
      url:
        case schema do
          MBTAV3API.Alert -> "/alerts"
          MBTAV3API.Facility -> "/facilities"
          MBTAV3API.Prediction -> "/predictions"
          MBTAV3API.Stop -> "/stops"
        end,
      params: filter_params
    ]
  end
end
