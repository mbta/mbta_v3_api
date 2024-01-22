defmodule MBTAV3API.MixProject do
  use Mix.Project

  def project do
    [
      app: :mbta_v3_api,
      version: "0.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MBTAV3API.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bypass, "~> 2.1", only: :test},
      {:con_cache, "~> 0.12.0"},
      {:credo, "~> 1.7", only: [:dev, :test]},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:mock, "~> 0.3", only: :test},
      {:plug, "~> 1.15", only: :test},
      {:sentry, "~> 7.0"},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:timex, "~> 3.7"}
    ]
  end
end
