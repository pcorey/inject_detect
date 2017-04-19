defmodule InjectDetect.Event.AddedExpectedQuery do
  defstruct id: nil,
            application_id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedExpectedQuery do

  alias InjectDetect.State.Query

  def apply(event, state) do
    query = %{
      collection: event.collection,
      queried_at: event.queried_at,
      query: event.query,
      type: event.type
    }
    key = Query.to_key(query)
    expected_queries_path = [:expected_queries, event.application_id, Query.to_key(query)]
    applications_path = [:applications, event.application_id, :expected_queries]
    state
    |> put_in(expected_queries_path, query)
    |> update_in(applications_path, &(&1 ++ [key]))
  end

end
