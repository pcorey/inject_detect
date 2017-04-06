defmodule InjectDetect.Event.IngestedUnexpectedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedUnexpectedQueries do

  import InjectDetect.State, only: [with_attrs: 1]

  def apply(event, state) do
    event.queries
    |> Enum.reduce(state, &apply_query(event, &1, &2))
  end

  def apply_query(event, query, state) do
    path = [:users,
            Access.all,
            :applications,
            with_attrs(id: event.application_id),
            :unexpected_queries,
            with_attrs_or_nil(query["collection"], query["query"], query["type"])]
    update_in(state, path, &add_or_update_query(&1, query))
  end

  def add_or_update_query(nil, %{"collection" => collection,
                                 "query" => query,
                                 "queried_at" => queried_at,
                                 "type" => type}) do
    %{collection: collection,
      count: 1,
      query: query,
      type: type,
      last_queried_at: queried_at}
  end

  def add_or_update_query(query, %{"queried_at" => queried_at}) do
    %{query | count: query.count + 1,
      last_queried_at: queried_at}
  end

  defp with_attrs_or_nil(collection, query, type) do
    fn (:get_and_update, queries, next) ->
      queries
      |> Enum.map(fn
        unexpected = %{collection: ^collection,
                      query: ^query,
                      type: ^type}  -> {true, next.(unexpected)}
        unexpected                  -> {false, {unexpected, unexpected}}
      end)
      |> (fn
            queries -> found = queries
                      |> Enum.map(&(elem(&1, 0)))
                      |> Enum.any?
                      case found do
                        true  -> Enum.map(queries, &(elem(&1, 1)))
                        false -> Enum.map(queries, &(elem(&1, 1))) ++ [next.(nil)]
                      end
          end).()
      |> :lists.unzip
    end
  end

end
