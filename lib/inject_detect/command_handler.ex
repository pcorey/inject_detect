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

  def handle(command, context \\ %{}) do
    GenServer.call(__MODULE__, {:handle, command, context})
  end

  # TODO: Add version
  def store_events(events) do
    reduce(events, Ecto.Multi.new(), fn
      (data = %type{}, multi) ->
        event = %Event{}
        |> put(:type, Atom.to_string(type))
        |> put(:data, Map.from_struct(data))
        insert(multi, data, event)
    end)
    |> Repo.transaction()
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

  def handle_call({:handle, command, context}, _, []) do
    Logger.debug("Handle: #{inspect command} with #{inspect context}")

    with {:ok, events, context} <- handle_command(command, context),
         {:ok, _}               <- store_events(events),
         _                      <- notify_listeners(events, context)
    do
      {:reply, {:ok, context}, []}
    else
      error -> {:reply, error, []}
    end
  end

end
