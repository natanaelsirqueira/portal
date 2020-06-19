defmodule Portal.MixProject do
  use Mix.Project

  def project do
    [
      app: :portal,
      name: "Portal",
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/natanaelsirqueira/portal",
      docs: [
        main: "Portal",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Portal.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.22.1", only: :dev, runtime: false}
    ]
  end
end
