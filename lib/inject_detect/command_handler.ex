defmodule InjectDetect.CommandHandler do
  use GenServer

  require Logger

  import Ecto.Multi, only: [insert: 3]
  import Enum, only: [reduce: 3]
  import Map, only: [put: 3]

  alias InjectDetect.Model.Event
  alias InjectDetect.Listener
  alias InjectDetect.Repo
  alias InjectDetect.Command

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle(command) do
    GenServer.call(__MODULE__, {:handle, command})
  end

  # TODO: Add version
  def store_events(events) do
    reduce(events, Ecto.Multi.new(), fn
      (data = %type{}, multi) ->
        event = %Event{}
        |> put(:type, Atom.to_string(type))
        |> put(:data, Map.from_struct(data))
        insert(multi, type, event)
    end)
    |> Repo.transaction()
  end

  def notify_listeners(events) do
    # TODO: Make calls async?
    for event = {type, _aggregate_id, _data} <- events do
      Registry.dispatch(Listener.Registry, type, fn entries ->
        for {pid, _} <- entries do
          if Process.alive?(pid), do: GenServer.call(pid, event)
        end
      end)
    end
  end

  def handle_call({:handle, command}, _, []) do
    Logger.debug("Handling #{inspect command}")

    with {:ok, events} <- Command.handle(command),
         {:ok, _}      <- store_events(events),
         _             <- notify_listeners(events)
    do
      {:reply, {:ok, events}, []}
    else
      error -> {:reply, error, []}
    end
  end

end
