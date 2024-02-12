defmodule MBTAV3API.MixProject do
  use Mix.Project

  def project do
    [
      app: :mbta_v3_api,
      version: "0.0.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :con_cache],
      mod: {MBTAV3API.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bypass, "~> 2.1", only: :test},
      {:castore, "~> 0.1"},
      {:con_cache, "~> 0.12.0"},
      {:credo, "~> 1.7", only: [:dev, :test]},
      {:csv, "~> 3.2"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:mock, "~> 0.3", only: :test},
      {:plug, "~> 1.15", only: :test},
      {:quixir, "~> 0.9", only: :test},
      {:sentry, "~> 7.0"},
      {:server_sent_event_stage, "~> 1.0"},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:timex, "~> 3.7"}
    ]
  end
end
