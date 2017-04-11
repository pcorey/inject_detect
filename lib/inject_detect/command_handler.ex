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
    {:ok, {0, %{}}}
  end

  def handle(command, context \\ %{}) do
    GenServer.call(__MODULE__, {:handle, command, context})
  end

  def store_events([], multi, {version, streams}) do
    {:ok, _} = Repo.transaction(multi)
    {:ok, {version, streams}}
  end

  def store_events([data = %type{} | events], multi, {version, streams}) do
    stream = apply(type, :stream, [data])
    %Event{version: version + 1,
           stream: stream,
           stream_version: (streams[stream] || 0) + 1}
    |> put(:type, Atom.to_string(type))
    |> put(:data, Map.from_struct(data))
    |> (&insert(multi, data, &1)).()
    |> (&store_events(events, &1, {version + 1,
                                   update_in(streams[stream], fn nil -> 1
                                                                   v -> v + 1 end)})).()
  end

  def store_events(events, {version, streams}) do
    store_events(events, Ecto.Multi.new(), {version, streams})
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

  def handle_call({:handle, command, context}, _, {version, streams}) do
    Logger.debug("Handle: #{inspect command} with #{inspect context}")

    with {:ok, events, context}    <- handle_command(command, context),
         {:ok, {version, streams}} <- store_events(events, {version, streams}),
         _                         <- notify_listeners(events, context)
    do
      {:reply, {:ok, context}, {version, streams}}
    else
      error -> {:reply, error, {version, streams}}
    end
  end

end
