defmodule InjectDetect.Listener.UnexpectedQueryDetector do
  use GenServer

  require Logger

  alias InjectDetect.Listener
  alias InjectDetect.State.User

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Registry.register(Listener.Registry,
                      InjectDetect.Event.UnexpectedQueryDetector,
                      [])
  end

  def handle_call({event, _context}, _, _) do
    IO.puts("ingested queries #{inspect event}")

    event.queries
    |> Enum.map(&tokenize/1)
    |> Enum.filter(&is_unexpected?(event.application_id, &1))
    # |> jk

    {:reply, :ok, []}
  end

  def tokenize(m), do: for {k, v} <- m, into: %{}, do: {String.to_atom(k), v}

  def is_unexpected?(application_id, query) do
    nil == UnexpectedQueries.find(%{application_id: application_id,
                                    collection: query[:collection],
                                    query: query[:query],
                                    type: query[:type]})
  end

end
