defmodule InjectDetect.Event.IngestedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedQueries do

  alias InjectDetect.State.Query

  def apply(event, state) do
    application = get_in(state, [:applications, event.application_id])
    Enum.reduce(event.queries, state, &apply_query(application, &1, &2))
  end

  # In training mode:
  def apply_query(application = %{training_mode: true}, query, state) do
    put_in(state, [:expected_queries, application.id, Query.to_key(query)], query)
    update_in(state, [:applications,
                      application.id,
                      :expected_queries], &(&1 ++ [Query.to_key(query)]))
  end

  # Not in training mode:
  def apply_query(application, query, state) do
    expected = is_expected?(state, application.id, query)
    apply_query(expected, application, query, state)
  end

  def apply_query(true, application, query, state), do: state
  def apply_query(false, application, query, state) do
    key = Query.to_key(query)
    update_in(state, [:unexpected_queries,
                      application.id,
                      key], &add_or_update_query(&1, application.id, query))
    update_in(state, [:applications,
                      application.id,
                      :unexpected_queries], &add_to_application(&1, key))
  end

  def is_expected?(state, application_id, query) do
    get_in(state, [:expected_queries, application_id, Query.to_key(query)]) != nil
  end

  def add_or_update_query(nil, _application_id, query) do
    %{collection: query["collection"],
      count: 1,
      query: query["query"],
      type: query["type"],
      queried_at: query["queried_at"]}
  end
  def add_or_update_query(current, _application_id, query) do
    %{current | count: current[:count] + 1,
                queried_at: query[:queried_at]}
  end

  def add_to_application(unexpected_queries, key) do
    Enum.uniq([key | unexpected_queries])
  end

end
