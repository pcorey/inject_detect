defmodule InjectDetect.State do
  use GenServer

  import Ecto.Query

  @initial %{users: []}

  def start_link do
    GenServer.start_link(__MODULE__, {0, @initial}, name: __MODULE__)
  end

  def init(initial) do
    # TODO: Figure out how to handle this in tests, rather than this crutch
    case Mix.env do
      :test ->
        handle_snapshot(nil, initial)
      _     ->
        InjectDetect.Model.Snapshot
        |> where([snapshot], snapshot.id > 0)
        |> order_by([snapshot], [desc: snapshot.id])
        |> first
        |> InjectDetect.Repo.one
        |> handle_snapshot(initial)
    end
  end

  def handle_snapshot(nil, initial) do
    {:ok, initial}
  end
  def handle_snapshot(%{event_id: event_id, state: state}, _initial) do
    {:ok, {event_id, :erlang.binary_to_term(state)}}
  end

  def get do
    {:ok, id, state} = GenServer.call(__MODULE__, :all)
    {:ok, state}
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def reset do
    GenServer.call(__MODULE__, :reset)
  end

  defp convert_to_event(%{type: type, data: data}) do
    type = String.to_atom(type)
    data = InjectDetect.atomify(data)
    InjectDetect.Event.convert_from(struct(type, data), 0)
  end

  defp get_events_since(id) do
    events = InjectDetect.Model.Event
    |> where([event], event.id > ^id)
    |> order_by([event], event.id)
    |> InjectDetect.Repo.all
    |> Enum.to_list
    {
      # Convert all events into their structs
      events |> Enum.map(&convert_to_event/1),
      # Grab the most recent "id" we've seen
      events |> List.last |> (&(if &1 do &1.id else id end)).()
    }
  end

  def apply_events(state, events) do
    Enum.reduce(events, state, &InjectDetect.State.Reducer.apply/2)
  end

  def handle_call(:all, _, {id, state}) do
    {events, id} = get_events_since(id)
    state = apply_events(state, events)
    {:reply, {:ok, id, state}, {id, state}}
  end

  def handle_call(:reset, _, _), do: {:reply, :ok, {0, @initial}}

end
