defmodule InjectDetect.CommandHandler do
  use GenServer

  require Logger

  import Ecto.Multi, only: [insert: 3]
  import Enum, only: [map: 2, reduce: 3]
  import Map, only: [put: 3]

  alias InjectDetect.Event
  alias InjectDetect.Repo

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle(command) do
    GenServer.call(__MODULE__, {:handle, command})
  end

  def register(listener) do
    GenServer.call(__MODULE__, {:register, listener})
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

  def notify_listeners(listeners, events) do
    for event <- events, listener <- listeners do
      Task.async(fn -> listener.(event) end)
    end
    |> map(&Task.await/1)
  end

  def handle_call({:handle, command = %module{}}, _, listeners) do
    Logger.debug("Handling %{command}...")

    with {:ok, events} <- apply(module, :handle, [command]),
         {:ok, _}      <- store_events(events),
         _             <- notify_listeners(listeners, events)
    do
      {:reply, {:ok, events}, listeners}
    else
      error -> {:reply, error, listeners}
    end
  end

  def handle_call({:register, listener}, _, listeners) do
    {:reply, {:ok, listeners ++ listener}, listeners ++ listener}
  end

end
