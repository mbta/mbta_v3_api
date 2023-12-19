defmodule MBTAV3API.MixProject do
  use Mix.Project

  def project do
    [
      app: :mbta_v3_api,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
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

  def cli do
    [preferred_envs: [update_test_data: :test]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ecto, "~> 3.11"},
      {:plug, "~> 1.0", only: :test},
      {:req, "~> 0.4.8"},
      {:server_sent_event_stage, "~> 1.1"},
      {:tzdata, "~> 1.1", only: :test},
      {:uniq, "~> 0.6", only: :test}
    ]
  end
end
