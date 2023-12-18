defmodule MBTAV3API.FlexEnum do
  @moduledoc """
  Like Ecto.Enum, but also casts `"SOME_VALUE"` and `"some-value"` into `:some_value`.
  With `values: [a: 1, b: 2], can additionally cast `1` into `:a` and `2` into `:b`.
  """
  use Ecto.ParameterizedType

  @impl true
  def type(_), do: :string

  @impl true
  def init(opts) do
    values = opts[:values]

    on_cast =
      values
      |> Stream.flat_map(fn value ->
        {value, extra_name} =
          case value do
            value when is_atom(value) -> {value, nil}
            {value, extra_name} when is_atom(value) -> {value, extra_name}
          end

        name = Atom.to_string(value)
        kebab_name = String.replace(name, "_", "-")
        upper_name = String.upcase(name)

        [
          {name, value},
          {kebab_name, value},
          {upper_name, value},
          unless is_nil(extra_name) do
            {extra_name, value}
          end
        ]
        |> Enum.reject(&is_nil/1)
      end)
      |> Map.new()

    %{on_cast: on_cast}
  end

  @impl true
  # conveniently, nil is an atom
  def cast(data, _params) when is_atom(data), do: {:ok, data}
  def cast(data, %{on_cast: on_cast}), do: Map.fetch(on_cast, data)
  def cast(_, _), do: :error

  @impl true
  def load(data, _, params), do: cast(data, params)

  @impl true
  def dump(nil, _, _), do: {:ok, nil}
  def dump(data, _, _) when is_atom(data), do: {:ok, Atom.to_string(data)}
  def dump(_, _, _), do: :error
end
