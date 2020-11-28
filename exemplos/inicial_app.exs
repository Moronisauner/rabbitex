defmodule Rabbitex.Application do
  use Application

  def start(_type, _args) do
    children = [
      Worker.Addition,
      Worker.Addition.child_spec([]),
      %{
        id: Worker.Addition,
        start: {
          Worker.Addition,
           :start_link,
          [[mode: :fast]]
        }
      },
      {Rabbitex.Consumer, []}
    ]

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: Rabbitex.Supervisor
    )
  end
end
