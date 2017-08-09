defmodule InjectDetect.Snapshotter do
  use GenServer

  import Ecto.Query

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end


  def init(_) do
    schedule_snapshot()
    {:ok, get_snapshot()}
  end


  def get_snapshot() do
    snapshot = InjectDetect.Model.Snapshot
    |> where([snapshot], snapshot.id > 0)
    |> order_by([snapshot], [desc: snapshot.id])
    |> first()
    |> InjectDetect.Repo.one
  end


  def take_snapshot(nil, {:ok, id, state}) do
    %InjectDetect.Model.Snapshot{event_id: id, state: :erlang.term_to_binary(state)}
    |> InjectDetect.Repo.insert
  end

  def take_snapshot(snapshot = %{event_id: old_id}, {:ok, id, state}) do
    size = Application.fetch_env!(:inject_detect, :snapshot_size)
    cond do
      (id - old_id) > size ->
        %InjectDetect.Model.Snapshot{event_id: id, state: :erlang.term_to_binary(state)}
        |> InjectDetect.Repo.insert
      true ->
        {:ok, snapshot}
    end
  end

  def take_snapshot(snapshot, _) do
    {:ok, snapshot}
  end


  def handle_info(:snapshot, old_snapshot) do
    {:noreply, take_snapshot(old_snapshot, InjectDetect.State.all)}
  end


  def schedule_snapshot do
    snapshot_interval = Application.fetch_env!(:inject_detect, :snapshot_interval)
    Process.send_after(self(), :snapshot, snapshot_interval)
  end


end
