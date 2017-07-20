defmodule InjectDetect.Command.IngestQueries do
  defstruct application_id: nil,
            queries: nil
end


defimpl InjectDetect.Command, for: InjectDetect.Command.IngestQueries do


  alias InjectDetect.Event.AddedExpectedQuery
  alias InjectDetect.Event.AddedUnexpectedQuery
  alias InjectDetect.Event.IngestedExpectedQuery
  alias InjectDetect.Event.IngestedQuery
  alias InjectDetect.Event.IngestedUnexpectedQuery
  alias InjectDetect.State
  alias InjectDetect.State.Application
  alias InjectDetect.State.User
  alias InjectDetect.State.Query


  def ingest_query(nil, query, %{training_mode: false}, {state, events}) do
    new_events = [struct(IngestedQuery, query),
                  struct(AddedUnexpectedQuery, query),
                  struct(IngestedUnexpectedQuery, query)]
    {State.apply_events(state, new_events), events ++ new_events}
  end

  def ingest_query(nil, query, %{training_mode: true}, {state, events}) do
    new_events = [struct(IngestedQuery, query),
                  struct(AddedExpectedQuery, query),
                  struct(IngestedExpectedQuery, query)]
    {State.apply_events(state, new_events), events ++ new_events}
  end

  def ingest_query(%{expected: true}, query, _application, {state, events}) do
    new_events = [struct(IngestedQuery, query),
                  struct(IngestedExpectedQuery, query)]
    {State.apply_events(state, new_events), events ++ new_events}
  end

  def ingest_query(%{expected: false}, query, _application, {state, events}) do
    new_events = [struct(IngestedQuery, query),
                  struct(IngestedExpectedQuery, query)]
    {State.apply_events(state, new_events), events ++ new_events}
  end


  def find_and_ingest_query(query, application, {state, events}) do
    Query.find(state, query.user_id, query.application_id, query)
    |> ingest_query(query, application, {state, events})
  end


  def ingest_queries(%{ingesting_queries: false}, _, _), do: InjectDetect.error "Not ingesting queries"

  def ingest_queries(nil, _, _), do: InjectDetect.error "Problem ingesting queries"

  def ingest_queries(application, command, state) do
    events = command.queries
    |> Enum.map(&update_query(&1, application))
    |> Enum.reduce({state, []}, &find_and_ingest_query(&1, application, &2))
    |> elem(1)
    |> List.flatten
    {:ok, events}
  end


  def update_query(query, application) do
    # Use application_id and user_id as part of id hash
    query = query
    |> Map.put_new(:application_id, application.id)
    |> Map.put_new(:user_id, application.user_id)
    query
    |> Map.put_new(:id, Query.hash(query))
  end


  def handle_for_user(%{active: true, locked: false}, application, command, state) do
    ingest_queries(application, command, state)
  end

  def handle_for_user(%{active: false}, _, _, _), do: InjectDetect.error "Account inactive"

  def handle_for_user(%{locked: true}, _, _, _), do: InjectDetect.error "Account locked"


  def handle(command, _context, state) do
    application = Application.find(state, command.application_id)
    User.find(state, application.user_id)
    |> handle_for_user(application, command, state)
  end

end
