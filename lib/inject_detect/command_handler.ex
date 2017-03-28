defmodule InjectDetect.CommandHandler do
  use GenServer

  require Logger

  import Ecto.Multi, only: [insert: 3]
  import Enum, only: [map: 2, reduce: 3]
  import Map, only: [put: 3]

  alias InjectDetect.Event
  alias InjectDetect.Handler
  alias InjectDetect.Listener
  alias InjectDetect.Repo

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle(command) do
    GenServer.call(__MODULE__, {:handle, command})
  end

  def handle_command({type, args}) do
    [{pid, module}] = Registry.lookup(Handler.Registry, type)
    res = GenServer.call(module, {type, args})
    res
  end

  def store_events(events) do
    reduce(events, Ecto.Multi.new(), fn
      ({type, aggregate_id, data}, multi) ->
        event = %Event{}
        |> put(:type, Atom.to_string(type))
        |> put(:aggregate_id, aggregate_id)
        |> put(:data, data)
        insert(multi, type, event)
    end)
    |> Repo.transaction()
  end

  def notify_listeners(events) do
    for event = {type, aggregate_id, data} <- events do
      Registry.dispatch(Listener.Registry, type, fn
        entries ->
          entries
          |> map(fn
            {pid, listener} ->
              Task.async(fn -> GenServer.call(listener, {type, aggregate_id, data}) end)
          end)
          |> map(&Task.await/1)
      end)
    end
  end

  def handle_call({:handle, command}, _, []) do
    Logger.debug("Handling %{command}...")

    with {:ok, events} <- handle_command(command),
         {:ok, _}      <- store_events(events),
         _             <- notify_listeners(events)
    do
      {:reply, {:ok, events}, []}
    else
      error -> {:reply, error, []}
    end
  end

end
