defmodule MBTAV3APITest.Data do
  require Logger
  use GenServer

  defmodule Request do
    defstruct [:path, :query]

    def from_conn(%Plug.Conn{request_path: path, query_string: query}) do
      %Request{
        path: path,
        query: query
      }
    end

    defimpl String.Chars do
      def to_string(%{path: path, query: query}) do
        %URI{
          path: path,
          query:
            case query do
              "" -> nil
              _ -> query
            end
        }
        |> URI.to_string()
      end
    end
  end

  defmodule Response do
    @enforce_keys [:id]
    defstruct [:id, :new_data, touched: false]
  end

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def respond(conn) do
    request = Request.from_conn(conn)

    stored_response = GenServer.call(__MODULE__, {:get, request})

    conn = conn |> Plug.Conn.put_resp_content_type("application/vnd.api+json")

    cond do
      updating_test_data?() ->
        data = update_response(conn, stored_response)

        Plug.Conn.send_resp(conn, :ok, Jason.encode_to_iodata!(data))

      is_nil(stored_response) ->
        Logger.warning("No test data for #{request}")

        Plug.Conn.send_resp(conn, :not_found, "{}")

      true ->
        Plug.Conn.send_file(conn, 200, response_path(stored_response))
    end
  end

  def write_new_data() do
    GenServer.call(__MODULE__, :write_new_data)
  end

  def warn_untouched() do
    GenServer.call(__MODULE__, :warn_untouched)
  end

  @impl GenServer
  def init(_) do
    initial_state =
      with meta_path <- test_data_path("meta.json"),
           {:ok, meta} <- File.read(meta_path),
           {:ok, meta} <- Jason.decode(meta) do
        meta
        |> Enum.flat_map(fn {path, path_data} ->
          Enum.map(path_data, fn {query, id} -> {path, query, id} end)
        end)
        |> Map.new(fn {path, query, id} ->
          {%Request{path: path, query: query}, %Response{id: id}}
        end)
      else
        _ -> %{}
      end

    {:ok, initial_state}
  end

  @impl GenServer
  def handle_call({:get, request}, _from, state) do
    # set touched: true if req in state, but do not put if req not in state

    case Map.get(state, request) do
      nil ->
        {:reply, nil, state}

      result ->
        result = %Response{result | touched: true}
        state = Map.put(state, request, result)
        {:reply, result, state}
    end
  end

  def handle_call({:put, request, data}, _from, state) do
    state =
      update_in(state[request], fn
        nil -> %Response{id: Uniq.UUID.uuid7(), new_data: data, touched: true}
        resp -> %Response{resp | new_data: data, touched: true}
      end)

    {:reply, :ok, state}
  end

  def handle_call(:write_new_data, _from, state) do
    {touched, untouched} =
      state
      |> Map.split_with(fn {_req, %Response{touched: touched}} -> touched end)

    untouched
    |> Enum.each(fn {req, resp} ->
      Logger.info("Deleting unused #{req}")
      File.rm!(response_path(resp))
    end)

    touched
    |> Enum.filter(fn {_req, %Response{new_data: new_data}} -> not is_nil(new_data) end)
    |> Enum.each(fn {_req, resp} ->
      File.write!(response_path(resp), Jason.encode_to_iodata!(resp.new_data))
    end)

    state = touched

    state
    |> Enum.group_by(
      fn {%Request{path: path}, _resp} -> path end,
      fn {%Request{query: query}, %Response{id: id}} -> {query, id} end
    )
    |> Map.new(fn {path, path_data} -> {path, Map.new(path_data)} end)
    |> then(&File.write!(test_data_path("meta.json"), Jason.encode_to_iodata!(&1)))

    {:reply, :ok, state}
  end

  def handle_call(:warn_untouched, _from, state) do
    unless updating_test_data?() do
      for {req, resp} <- state do
        unless resp.touched do
          Logger.warning("Unused test data for #{req}")
        end
      end
    end

    {:reply, :ok, state}
  end

  defp updating_test_data? do
    Application.get_env(:mbta_v3_api, :updating_test_data?, false)
  end

  defp test_data_path(file) do
    Application.app_dir(:mbta_v3_api, ["priv", "test_data", file])
  end

  defp response_path(%Response{id: id}) do
    test_data_path("#{id}.json")
  end

  defp update_response(conn, stored_response) do
    request = Request.from_conn(conn)

    expected_response =
      with %Response{} <- stored_response,
           {:ok, old_data} <- File.read(response_path(stored_response)),
           {:ok, old_data} <- Jason.decode(old_data) do
        old_data
      else
        _ -> nil
      end

    %Req.Response{status: 200, body: actual_response} =
      Req.get!(Plug.Conn.request_url(conn), headers: conn.req_headers)

    cond do
      is_nil(expected_response) ->
        Logger.info("Creating #{request}")
        GenServer.call(__MODULE__, {:put, request, actual_response})

      expected_response == actual_response ->
        :ok

      true ->
        diff =
          ExUnit.Formatter.format_assertion_error(%ExUnit.AssertionError{
            left: expected_response,
            right: actual_response,
            context: nil
          })

        Logger.warning("Response for #{request} changed: #{diff}")
    end

    actual_response
  end
end
