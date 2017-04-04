defmodule InjectDetect.Event.IngestedUnexpectedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedUnexpectedQueries do

  alias InjectDetect.State

  def apply(event, state) do
    event.queries
    |> Enum.reduce(state, fn
      (query, state) ->
        update_in(state,
                  [:users,
                  Access.all,
                  :applications,
                  State.all_with(:id, event.application_id),
                  :unexpected_queries,
                  State.all_with(:query, query["query"])],
          fn
            # Found new unexpected query
            nil ->
              %{collection: query["collection"],
                count: 1,
                query: query["query"],
                type: query["type"],
                last_queried_at: query["queried_at"]}
            # Found existing unexpected query
            (found = %{}) ->
              %{collection: found.collection,
                count: found.count + 1,
                query: found.query,
                type: found.type,
                last_queried_at: query["queried_at"]}
          end)
    end)
  end

end
