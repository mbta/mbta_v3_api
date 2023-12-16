defmodule MBTAV3API.JSONAPI.Included do
  alias MBTAV3API.JSONAPI.Resource
  alias MBTAV3API.JSONAPI.ResourceIdentifier

  @type t :: %__MODULE__{raw_data: list(Resource.t()), agent: Agent.agent()}

  defstruct [:raw_data, :agent]

  def start(data, root_ids) do
    seed_value = root_ids |> Map.new(&{{&1.type, &1.id}, :circular_reference})

    {:ok, pid} = Agent.start_link(fn -> seed_value end)

    %__MODULE__{raw_data: data, agent: pid}
  end

  def fetch!(
        %__MODULE__{raw_data: raw_data, agent: agent} = included,
        %ResourceIdentifier{type: type, id: id}
      ) do
    case Agent.get(agent, & &1[{type, id}]) do
      :circular_reference ->
        # TODO decide if nil is the right way to present these
        nil

      cached_value when not is_nil(cached_value) ->
        cached_value

      nil ->
        Agent.update(agent, &Map.put(&1, {type, id}, :circular_reference))

        result =
          case Enum.find(raw_data, &(&1.type == type and &1.id == id)) do
            raw_value when not is_nil(raw_value) ->
              Resource.decode!(raw_value, included)

            nil ->
              raise "no included resource #{inspect({type, id})}"
          end

        Agent.update(agent, &Map.put(&1, {type, id}, result))

        result
    end
  end

  def stop(%__MODULE__{agent: agent}) do
    Agent.stop(agent)
  end
end
