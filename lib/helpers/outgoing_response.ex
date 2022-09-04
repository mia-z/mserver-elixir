defmodule Helpers.OutgoingResponse do
  require Logger

  use Task

  @spec start_link({:"$inet", atom, any}, {:"$inet", atom, any}) :: {:ok, pid}
  def start_link(socket, client) do
    Task.start_link(__MODULE__, :run, [socket, client])
  end

  @spec run({:"$inet", atom, any}, {:"$inet", atom, any}) :: :ok
  def run(_socket, client) do
    Logger.info "Running response task (OUT)"

    case :gen_tcp.send(client, ["HTTP/1.1 200 OK\r\n\r\n"]) do
      {:error, reason} ->
        Logger.info "error when sending response #{reason}"

      :ok ->
        Logger.info "sent response"
        :gen_tcp.close(client);
    end
  end
end
