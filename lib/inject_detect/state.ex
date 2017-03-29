defmodule InjectDetect.State do
  use GenServer

  import Ecto.Query

  @initial %{
    users: %{}
  }

  def start_link do
    GenServer.start_link(__MODULE__, {0, @initial}, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  # TODO: Add version
  defp convert_to_event(%{type: type, data: data}) do
    type = String.to_atom(type)
    data = for {k, v} <- data, into: %{}, do: {String.to_atom(k), v}
    apply(type, :convert_from, [data, 0])
  end

  defp get_events_since(version) do
    events = InjectDetect.Model.Event
    |> where([event], event.id > ^version)
    |> order_by([event], event.id)
    |> InjectDetect.Repo.all
    |> Enum.to_list

    # Convert all events into their structs
    {events |> Enum.map(&convert_to_event/1),
    # Grab the most revent "version" we've seen
     events |> List.last |> (fn nil       -> version
                                %{id: id} -> id end).()}
  end

  def handle_call(:get, _, {version, state}) do
    {events, version} = get_events_since(version)
    state = Enum.reduce(events, state, &InjectDetect.State.Reducer.apply/2)
    {:reply, {:ok, state}, {version, state}}
  end

  def user(field, value) do
    {:ok, state} = get()
    Enum.find(state.users, fn
      {_, %{^field => ^value}} -> true
      _                        -> false
    end)
    |> case do
         {_id, user} -> user
         _           -> nil
       end
  end

end
