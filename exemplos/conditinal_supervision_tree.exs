
defmodule Rabbitex.Application do
  use Application

  def start(_type, _args) do
    deployment_type()
    |> children_for()
    |> Supervisor.start_link(
      strategy: :one_for_one,
      name: Rabbitex.Supervisor
    )
  end

  defp children_for("worker") do
    [
      Repo,
      RabbitmqPublisher,
      JobQueueA,
      JobQueueB,
      OtherStuff
    ]
  end

  defp children_for("api") do
    [Repo, Endpoint]
  end

  defp children_for("presentation") do
    [
      Worker.Addition,
      Rabbitex.Consumer
    ]
  end

  defp deployment_type do
    System.get_env("DEPLOYMENT_TYPE", "presentation")
  end
end
