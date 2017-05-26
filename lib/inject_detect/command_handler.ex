defmodule InjectDetect.CommandHandler do

  def store_events([], multi), do: InjectDetect.Repo.transaction(multi)
  def store_events([data = %type{} | events], multi) do
    %InjectDetect.Model.Event{}
    |> Map.put(:type, Atom.to_string(type))
    |> Map.put(:data, Map.from_struct(data))
    |> (&Ecto.Multi.insert(multi, data, &1)).()
    |> (&store_events(events, &1)).()
  end
  def store_events(events), do: store_events(events, Ecto.Multi.new())

  def notify_listeners(events, context, listeners) do
    Enum.map(events, fn event -> Enum.map(listeners, &(&1.(event, context))) end)
  end

  def handle_command(command, context) do
    case InjectDetect.Command.handle(command, context) do
      {:ok, events, context} -> {:ok, events, context}
      {:ok, events}          -> {:ok, events, context}
      error                  -> error
    end
  end

  def handle(command, context, listeners) do
    with {:ok, events, context} <- handle_command(command, context),
         {:ok, _}               <- store_events(events)
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
