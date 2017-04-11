defmodule InjectDetect.State do
  use GenServer

  import Ecto.Query

  @initial %{users: %{},
             applications: %{},
             application_tokens: %{},
             unexpected_queries: %{},
             expected_queries: %{}}

  def start_link do
    GenServer.start_link(__MODULE__, {0, @initial}, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def version do
    GenServer.call(__MODULE__, :version)
  end

  def reset do
    GenServer.call(__MODULE__, :reset)
  end

  # TODO: Add version
  defp convert_to_event(%{type: type, data: data}) do
    type = String.to_atom(type)
    data = for {k, v} <- data, into: %{}, do: {String.to_atom(k), v}
    apply(type, :convert_from, [data, 0])
  end

  defp get_events_since(version) do
    IO.puts("since #{version}")
    events = InjectDetect.Model.Event
    |> where([event], event.version > ^version)
    |> order_by([event], event.version)
    |> InjectDetect.Repo.all
    |> Enum.to_list
    |> IO.inspect

    # Convert all events into their structs
    {events |> Enum.map(&convert_to_event/1),
    # Grab the most recent "version" we've seen
     events |> List.last |> (&(if &1 do &1.version else version end)).()}
  end

  def handle_call(:get, _, {version, state}) do
    {events, version} = get_events_since(version)
    state = Enum.reduce(events, state, &InjectDetect.State.Reducer.apply/2)
    {:reply, {:ok, state}, {version, state}}
  end

  def handle_call(:version, _, {version, state}) do
    {events, version} = get_events_since(version)
    state = Enum.reduce(events, state, &InjectDetect.State.Reducer.apply/2)
    {:reply, {:ok, version}, {version, state}}
  end

  def handle_call(:reset, _, _), do:
    {:reply, :ok, {0, @initial}}

end
