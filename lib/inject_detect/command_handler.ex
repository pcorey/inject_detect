defmodule InjectDetect.CommandHandler do
  use GenServer

  require Logger

  import Ecto.Multi, only: [insert: 3]
  import Enum, only: [reduce: 3]
  import GenServer, only: [call: 2]
  import Map, only: [put: 3]

  alias InjectDetect.Model.Event
  alias InjectDetect.Listener
  alias InjectDetect.Repo
  alias InjectDetect.Command

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, 0}
  end

  def handle(command, context \\ %{}) do
    GenServer.call(__MODULE__, {:handle, command, context})
  end

  def store_events([], multi, version) do
    {:ok, _} = Repo.transaction(multi)
    {:ok, version}
  end

  def store_events([data = %type{} | events], multi, version) do
    stream = apply(type, :stream, [data])
    %Event{version: version + 1,
           stream: stream}
    |> put(:type, Atom.to_string(type))
    |> put(:data, Map.from_struct(data))
    |> (&insert(multi, data, &1)).()
    |> (&store_events(events, &1, version + 1)).()
  end

  def store_events(events, version) do
    store_events(events, Ecto.Multi.new(), version)
  end

  def notify_listeners(events, context) do
    # TODO: Make calls async?
    for event = %type{} <- events do
      Registry.dispatch(Listener.Registry, type, fn entries ->
        for {pid, _} <- entries do
          if Process.alive?(pid), do: call(pid, {event, context})
        end
      end)
    end
  end

  def handle_command(command, context) do
    case Command.handle(command, context) do
      {:ok, events, context} -> {:ok, events, context}
      {:ok, events}          -> {:ok, events, context}
      error                  -> error
    end
  end

  def handle_call({:handle, command, context}, _, version) do
    Logger.debug("Handle: #{inspect command} with #{inspect context}")

    with {:ok, events, context}    <- handle_command(command, context),
         {:ok, version} <- store_events(events, version),
         _                         <- notify_listeners(events, context)
    do
      {:reply, {:ok, context}, version}
    else
      error -> {:reply, error, version}
    end
  end

end
