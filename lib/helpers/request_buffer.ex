defmodule Helpers.RequestBuffer do
  require Logger

  use GenServer

  @initial_state ""
  # @eol <<10>>

  @impl true
  def init(initial_state \\ @initial_state) do
    {:ok, initial_state}
  end

  def create do
    GenServer.start_link(__MODULE__, @initial_state)
  end

  def update(pid \\ __MODULE__, data) do
    Logger.info "Updating request #{inspect pid}"
    GenServer.cast(pid, {:update, data})
  end

  @impl true
  def handle_cast({:update, data}, buffer) do
    {:noreply, buffer <> data}
  end

  def flush(pid \\ __MODULE__) do
    Logger.info "Flushing request #{inspect pid}"
    GenServer.call(pid, :flush)
  end

  @impl true
  def handle_call(:flush, _from, buffer) do
    {:reply, :flushed, "done", buffer}
  end
end
