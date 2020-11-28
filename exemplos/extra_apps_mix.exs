defmodule Rabbitex.MixProject do
  use Mix.Project

  def project do
    [
      app: :rabbitex,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Rabbitex.Application, []},
      extra_applications: [:lager, :logger]
    ]
  end

  defp deps do
    [
      {:amqp, "~> 1.6.0", runtime: false}
    ]
  end
end
