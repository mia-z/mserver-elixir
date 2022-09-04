defmodule Mserver.Rest.Server do
  require Logger

  use Agent

  @spec start_link(any) :: {:error, any} | {:ok, pid}
  def start_link(initial_args) do
    start_server()
    Agent.start_link(fn -> initial_args end, name: :server)
  end

  defp start_server() do
    pid = spawn fn ->
      case :gen_tcp.listen(4001, [:binary, active: false, reuseaddr: true]) do
        {:ok, socket} ->
          Logger.info "listening on 4001"
          listener(socket)
        {:error, reason} ->
          Logger.error reason
      end
    end
    {:ok, pid}
  end

  defp listener(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info "Got new request from #{inspect(client)}"
    Task.Supervisor.start_child(Request.TaskSupervisor, Helpers.IncomingRequest, :run, [socket, client])

    listener(socket)
  end
end
