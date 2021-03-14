defmodule Notifications.Boundary.JobManager do
  @moduledoc false

  alias Notifications.Core.Job
  alias Notifications.Boundary.SendNotification

  use GenServer
  require Logger

  def remove_job(id) do
    GenServer.call(__MODULE__, {:remove, id})
  end

  def add_job(%Job{} = job) do
    GenServer.call(__MODULE__, {:add, job})
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__, hibernate_after: 5_000)
  end

  def init(state), do: {:ok, state}

  def handle_call(:state, _from, state), do: {:reply, state, state}

  def handle_call({:add, %Job{max_delay: 0, id: id} = job}, _from, state) do
    Logger.info("Processing immediate notification", job_id: id)
    SendNotification.run(job)
    {:reply, :ok, state}
  end

  def handle_call({:add, %Job{id: id, metadata: m} = job}, _from, state) do
    Logger.info("Registering notification for processing later", job_id: id)
    m = Map.put(m, :timer_ref, schedule_send(job))
    {:reply, :ok, Map.put(state, id, %{job | metadata: m})}
  end

  def handle_call({:remove, id}, _from, state) do
    case Map.get(state, id) do
      nil -> :ok
      %{metadata: %{timer_ref: ref}} -> :erlang.cancel_timer(ref)
    end

    {:reply, :ok, Map.delete(state, id)}
  end

  def handle_info({:send, id}, state) do
    Logger.info("Processing notification", job_id: id)
    SendNotification.run(Map.get(state, id))
    {:noreply, state}
  end

  defp schedule_send(%Job{id: id, max_delay: delay} = _job) do
    Process.send_after(self(), {:send, id}, delay * 1000)
  end
end
