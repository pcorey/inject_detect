defmodule InjectDetect.Event.IngestedUnexpectedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedUnexpectedQueries do

  def apply(event = %{queries: queries}, state) do
    queries
    |> Enum.map(&tokenize/1)
    |> Enum.reduce(state, &apply_query(event, &1, &2))
  end

  def tokenize(query), do:
    for {k, v} <- query, into: %{}, do: {String.to_atom(k), v}

  def apply_query(event, query, state) do
    application = get_in(state, [:applications, event.application_id])
    key = %{application_id: event.application_id,
            collection: query.collection,
            type: query.type,
            query: query.query}
    update_in(state, [:unexpected_queries,
                      key], &add_or_update_query(&1, application.id, query))
    update_in(state, [:applications,
                      event.application_id,
                      :unexpected_queries], &add_to_application(&1, key))
  end

  def add_or_update_query(nil, application_id, query) do
    %{collection: query[:collection],
      count: 1,
      query: query[:query],
      type: query[:type],
      last_queried_at: query[:queried_at],
      application_id: application_id}
  end

  def add_or_update_query(current, application_id, query) do
    %{current | count: current[:count] + 1,
                last_queried_at: query[:queried_at]}
  end

  def add_to_application([], key), do:
    [key] # Add it to the end.
  def add_to_application([key | queries], key), do:
    [key | queries] # Found it!
  def add_to_application([head | queries], key), do:
    [head | add_to_application(queries, key)] # Keep searching...

end
