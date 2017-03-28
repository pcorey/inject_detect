defmodule InjectDetect.State do
  use GenServer

  # use InjectDetect.State.UserReducer

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

  defp get_events_since(version) do
    InjectDetect.Event
    |> where([event], event.id > ^version)
    |> order_by([event], event.id)
    |> InjectDetect.Repo.all
    |> Enum.to_list
  end

  defp transform_data(data) do
    for {key, val} <- data, into: %{}, do: {String.to_atom(key), val}
  end

  defp transform_events(events) do
    Enum.map(events, fn
      %{type: type, data: data} -> {String.to_atom(type), transform_data(data)}
    end)
  end

  def apply_event({:got_started, user}, state) do
    put_in(state, [:users, user.id], %{
          id: user.id,
          auth_token: user.auth_token,
          email: user.email,
           })
  end

  def apply_event({:requested_sign_in_link, data}, state) do
    put_in(state, [:users, data.id, :requested_token], data.requested_token)
  end

  def apply_event({:signed_out, data}, state) do
    put_in(state, [:users, data.user_id, :auth_token], nil)
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

  def find_user(field, value) do
    {:ok, state} = InjectDetect.State.get()
    Enum.find(state.users, fn
      {_, %{^field => ^value}} -> true
      _ -> false
    end)
    |> case do
         {id, user} -> user
         _ -> nil
       end
  end

end
