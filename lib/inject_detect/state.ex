defmodule InjectDetect.State do
  use GenServer

  import Ecto.Query

  def start_link do
    base = InjectDetect.State.Base.new()
    GenServer.start_link(__MODULE__, {0, base}, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
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

  defp get_events_since(id) do
    events = InjectDetect.Model.Event
    |> where([event], event.id > ^id)
    |> order_by([event], event.id)
    |> InjectDetect.Repo.all
    |> Enum.to_list

    # Convert all events into their structs
    {events |> Enum.map(&convert_to_event/1),
    # Grab the most revent "id" we've seen
     events |> List.last |> (&(if &1 do &1.id else id end)).()}
  end

  def user(field, value) do
    get()
    |> elem(1)
    |> get_in([:users, all_with([{field, value}])])
    |> List.first
  end

  def application(field, value) do
    get()
    |> elem(1)
    |> get_in([:users,
               Access.all,
               :applications,
               all_with([{field, value}])])
    |> List.flatten
    |> List.first
  end

  def handle_call(:get, _, {id, state}) do
    {events, id} = get_events_since(id)
    state = Enum.reduce(events, state, &InjectDetect.State.Reducer.apply/2)
    {:reply, {:ok, state}, {id, state}}
  end

  def handle_call(:reset, _, _), do:
    {:reply, :ok, {0, InjectDetect.State.Base.new()}}

  def with_attrs(attrs) do
    matches = fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end
    fn
      (:get, users, next) ->
        Enum.filter(users, matches)
        |> Enum.map(next)
      (:get_and_update, users, next) ->
        Enum.map(users, fn user -> matches.(user)
        |> case do
              true  -> next.(user)
              false -> {nil, user}
            end
        end)
        |> :lists.unzip
    end
  end

  def all_with(filters) do
    fn
      (:get, list, next) ->
        Enum.filter(list, fn
          item -> Enum.all?(filters, fn {k, v} -> item[k] == v end)
        end)
        |> Enum.map(next)

      (:get_and_update, list, next) ->
        Enum.map(list, fn
          item -> Enum.all?(filters, fn {k, v} -> item[k] == v end)
                  |> case do
                      true  -> next.(item)
                      false -> {item, item}
                    end
        end)
        |> :lists.unzip
    end
  end

end
