defmodule InjectDetect.Command.IngestQueries do
  defstruct application_id: nil,
            queries: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.IngestQueries do

  alias InjectDetect.Event.AddedExpectedQuery
  alias InjectDetect.Event.IngestedQuery
  alias InjectDetect.Event.IngestedExpectedQuery
  alias InjectDetect.Event.IngestedUnexpectedQuery
  alias InjectDetect.State
  alias InjectDetect.State.Application
  alias InjectDetect.State.Query

  def added_expected_queries(command) do
    base = %{application_id: command.application_id}
    command.queries
    |> Enum.filter(&Query.is_unexpected?(State.get(), command.application_id, &1))
    |> Enum.map(&Map.delete(&1, :queried_at))
    |> Enum.uniq()
    |> Enum.map(&struct(AddedExpectedQuery, Map.merge(&1, base)))
  end

  def ingested_queries(command) do
    base = %{application_id: command.application_id}
    Enum.map(command.queries, &struct(IngestedQuery, Map.merge(&1, base)))
  end

  def ingested_expected_queries(queries, application_id) do
    base = %{application_id: application_id}
    Enum.map(queries, &struct(IngestedExpectedQuery, Map.merge(&1, base)))
  end

  def ingested_expected_queries(command) do
    command.queries
    |> Enum.filter(&Query.is_expected?(State.get(), command.application_id, &1))
    |> ingested_expected_queries(command.application_id)
  end

  def ingested_unexpected_queries(queries, application_id) do
    base = %{application_id: application_id}
    Enum.map(queries, &struct(IngestedUnexpectedQuery, Map.merge(&1, base)))
  end

  def ingested_unexpected_queries(command) do
    command.queries
    |> Enum.filter(&Query.is_unexpected?(State.get(), command.application_id, &1))
    |> ingested_unexpected_queries(command.application_id)
  end

  # Application not found:
  def ingest_for_application(nil, command) do
    {:error, %{code: :invalid_token,
               error: "Invalid application token",
               message: "Invalid token"}}
  end

  # Training mode:
  def ingest_for_application(%{training_mode: true}, command) do
    {:ok, ingested_queries(command) ++
          added_expected_queries(command) ++
          ingested_expected_queries(command.queries, command.application_id)}
  end

  # Live mode:
  def ingest_for_application(%{training_mode: false}, command) do
    {:ok, ingested_queries(command) ++
          ingested_expected_queries(command) ++
          ingested_unexpected_queries(command)}
  end

  def handle(command, _context) do
    Application.find(command.application_id)
    |> ingest_for_application(command)
  end

end
