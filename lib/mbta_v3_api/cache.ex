defmodule MBTAV3API.Cache do
  @moduledoc """
  Handles caching for static data in the V3 API.

  May one day need to be configurable and generic.
  """

  use GenServer

  def start_link(args) do
    {start_args, init_args} = Keyword.split(args, [:name])
    GenServer.start_link(__MODULE__, init_args, name: Keyword.get(start_args, :name, __MODULE__))
  end

  @spec put(Ecto.Schema.embedded_schema(), timeout(), GenServer.server()) :: :ok | :error
  def put(value, ttl, server \\ __MODULE__) do
    GenServer.call(server, {:put, value, ttl})
  end

  @spec get(module(), String.t(), GenServer.server()) ::
          {:ok, Ecto.Schema.embedded_schema()} | :error
  def get(type, id, server \\ __MODULE__) do
    GenServer.call(server, {:get, type, id})
  end

  @spec put_all(
          String.t(),
          list(Ecto.Schema.embedded_schema()),
          timeout(),
          GenServer.server()
        ) :: :ok | :error
  def put_all(key, values, ttl, server \\ __MODULE__) do
    GenServer.call(server, {:put_all, key, values, ttl})
  end

  @spec get_all(String.t(), GenServer.server()) ::
          {:ok, list(Ecto.Schema.embedded_schema())} | :error
  def get_all(key, server \\ __MODULE__) do
    GenServer.call(server, {:get_all, key})
  end

  @spec clear(GenServer.server()) :: :ok | :error
  def clear(server \\ __MODULE__) do
    GenServer.call(server, :clear)
  end

  @impl true
  def init(_args) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:put, value, ttl}, _from, state) do
    ConCache.put(MBTAV3API.Cache.Backend, cache_key(value), %ConCache.Item{value: value, ttl: ttl})

    {:reply, :ok, state}
  end

  def handle_call({:get, type, id}, _from, state) do
    response =
      ConCache.get(MBTAV3API.Cache.Backend, cache_key(type, id))
      |> case do
        %^type{id: ^id} = result -> {:ok, result}
        _ -> :error
      end

    {:reply, response, state}
  end

  def handle_call({:put_all, key, values, ttl}, _from, state) do
    ConCache.put(MBTAV3API.Cache.Backend, cache_key_all(key), %ConCache.Item{
      value: values,
      ttl: ttl
    })

    {:reply, :ok, state}
  end

  def handle_call({:get_all, key}, _from, state) do
    response =
      ConCache.get(MBTAV3API.Cache.Backend, cache_key_all(key))
      |> case do
        result when is_list(result) -> {:ok, result}
        _ -> :error
      end

    {:reply, response, state}
  end

  def handle_call(:clear, _from, state) do
    table = ConCache.ets(MBTAV3API.Cache.Backend)
    :ets.delete_all_objects(table)
    {:reply, :ok, state}
  end

  defp cache_key(%type{id: id}), do: cache_key(type, id)

  defp cache_key(type, id) when is_atom(type) and is_binary(id) do
    {:one, type, id}
  end

  defp cache_key_all(key) do
    {:all, key}
  end
end
