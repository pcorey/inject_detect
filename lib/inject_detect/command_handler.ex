defmodule InjectDetect.CommandHandler do

  def store_events([], multi, id), do: InjectDetect.Repo.transaction(multi)
  def store_events([data = %type{} | events], multi, id) do
    %InjectDetect.Model.Event{}
    |> Map.put(:type, Atom.to_string(type))
    |> Map.put(:data, Map.from_struct(data))
    # Uncomment to add global optimistic lock.
    # TODO: Figure out better locking mechanism.
    #       Maybe each command/event can have a "metadata function" that can set id/stream?
    # |> Map.put(:id, id)
    |> (&Ecto.Multi.insert(multi, id, &1)).()
    |> (&store_events(events, &1, id + 1)).()
  end
  def store_events(events, id), do: store_events(events, Ecto.Multi.new(), id + 1)

  def notify_listeners(events, context, listeners) do
    Enum.map(events, fn event -> Enum.map(listeners, &(&1.(event, context))) end)
  end

  def handle_command(command, context, state) do
    case InjectDetect.Command.handle(command, context, state) do
      {:ok, events, context} -> {:ok, events, context}
      {:ok, events}          -> {:ok, events, context}
      error                  -> error
    end
  end

  def handle(command, context, listeners) do
    with {:ok, id, state}       <- InjectDetect.State.all,
         {:ok, events, context} <- handle_command(command, context, state),
         {:ok, _}               <- store_events(events, id)
    do
      notify_listeners(events, context, listeners)
      {:ok, context}
    end
  end

  def handle(command, context \\ %{}) do
    listeners = Application.fetch_env!(:inject_detect, :listeners)
    handle(command, context, listeners)
  end

end
