defmodule InjectDetect.State do
  use GenServer

  use InjectDetect.State.GotStartedReducer

  import Ecto.Query

  def start_link do
    GenServer.start_link(__MODULE__, {0, %{}}, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  defp get_events_since(version) do
    IO.puts("getting from #{version}")
    InjectDetect.Event
    |> where([event], event.id > ^version)
    |> order_by([event], event.id)
    |> InjectDetect.Repo.all
    |> Enum.to_list
  end

  defp transform_events(events) do
    Enum.map(events, fn
      %{type: type, data: data} -> {String.to_atom(type), data}
    end)
  end

  def apply_event({type, _data}, _state) do
    IO.puts("Unexpected type #{type}")
  end

  defp get_next_state(events, state) do
    events
    |> transform_events
    |> Enum.reduce(state, &apply_event/2)
  end

  defp get_next_version(events, version) do
    case List.last(events) do
      %{id: id} -> version = id
      _ -> version = version
    end
  end

  def handle_call(:get, _, {version, state}) do
    events = get_events_since(version)
    state = get_next_state(events, state)
    version = get_next_version(events, version)

    {:reply, {:ok, state}, {version, state}}
  end

end
