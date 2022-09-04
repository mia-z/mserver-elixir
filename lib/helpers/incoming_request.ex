defmodule Helpers.IncomingRequest do
  require Logger

  use Task

  def start_link(socket, client) do
    Task.start_link(__MODULE__, :run, [socket, client])
  end

  def run(socket, client) do
    Logger.info "Running request task (IN)"
    Logger.info inspect(client)

    handle_request(socket, client)

    handle_response(socket, client)

    :done
  end

  defp handle_request(_socket, client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, data} ->
        # parsed_request =
        HttpRequest.parse(data)
        # Helpers.RequestBuffer.update(buffer, parsed_request)
      {:error, :closed} ->
        Logger.info "Socket terminating #{inspect(:closed)}"
    end
  end

  defp handle_response(socket, client) do
    Task.Supervisor.start_child(Response.TaskSupervisor, Helpers.OutgoingResponse, :run, [socket, client])
  end
end
