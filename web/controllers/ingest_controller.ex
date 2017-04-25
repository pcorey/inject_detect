defmodule InjectDetect.IngestController do
  use InjectDetect.Web, :controller

  alias InjectDetect.Command.IngestQueries
  alias InjectDetect.State.Application

  import InjectDetect.CommandHandler, only: [handle: 2]

  def create(conn, %{"application_token" => application_token,
                     "queries" => queries}) do

    application = Application.find(token: application_token)

    queries = Enum.map(queries, fn
      query -> for {k, v} <- query, into: %{}, do: {String.to_atom(k), v}
    end)

    command = %IngestQueries{application_id: application.id, queries: queries}
    case handle(command, %{}) do
      {:ok, _} ->
        json conn, %{ok: 100}
      {:error, error} ->
        json conn, %{error: error.error}
    end

  end
end
