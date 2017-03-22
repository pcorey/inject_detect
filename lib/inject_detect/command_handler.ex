defmodule InjectDetect.CommandHandler do
  use GenServer

  require Logger

  import InjectDetect.Repo, only: [insert: 1]

  alias InjectDetect.Event

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def handle(command) do
    GenServer.call(__MODULE__, {:handle, command})
  end

  def persist_event(event = {type, aggregate_id, data}) do
    insert(%Event{
      type: Atom.to_string(type),
      aggregate_id: aggregate_id,
      data: data
    })
    event
  end

  def handle_call({:handle, command = %module{}}, _, state) do
    Logger.debug("Handling %{command}...")

    events = apply(module, :handle, [command])
    |> Enum.map(&persist_event/1)

    {:reply, {:ok, events}, state}
  end

end
