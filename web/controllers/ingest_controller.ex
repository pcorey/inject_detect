defmodule InjectDetect.IngestController do
  use InjectDetect.Web, :controller

  alias InjectDetect.Command.IngestQueries
  alias InjectDetect.State.Application

  import InjectDetect.CommandHandler, only: [handle: 2]

  def ingest_for_application(nil, _queries), do: {:error, "Application not found."}
  def ingest_for_application(application, queries) do
    %IngestQueries{application_id: application.id, queries: queries}
    |> handle(%{})
  end

  def create(conn, %{"application_token" => application_token,
                     "queries" => queries}) do

    application = Application.find(token: application_token)

    queries = Enum.map(queries, fn
      query -> for {k, v} <- query, into: %{}, do: {String.to_atom(k), v}
    end)

    # TODO: Timing out on lots of requests (half way through 5000)
    case ingest_for_application(application, queries) do
      {:ok, _} ->
        json conn, %{ok: 100}
      {:error, reason} ->
        json conn, %{error: reason}
    end

  end
end
