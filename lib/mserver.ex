defmodule Mserver do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Request.TaskSupervisor},
      {Task.Supervisor, name: Response.TaskSupervisor},
      {Mserver.Rest.Server, nil}
    ]

    opts = [strategy: :one_for_one, name: Mserver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
