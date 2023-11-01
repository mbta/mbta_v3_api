defmodule V3Api.MixProject do
  use Mix.Project

  def project do
    [
      app: :v3_api,
      version: "0.0.1",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {V3Api.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bypass, "~> 2.1", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test]},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:plug, "~> 1.15", only: :test},
      {:sentry, "~> 7.0"},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false}
    ]
  end
end
