defmodule InjectDetect.Event.IngestedUnexpectedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedUnexpectedQueries do

  defp that_match(collection, query, type) do
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

  def apply(event, state) do
    event.queries
    |> Enum.reduce(state, fn
      (%{"collection" => collection,
         "query" => query,
         "queried_at" => queried_at,
         "type" => type}, state) ->
        update_in(state,
          [:users,
           Access.all,
           :applications,
           InjectDetect.State.all_with(id: event.application_id),
           :unexpected_queries,
           that_match(collection, query, type)], fn

            # New unexpected query
            nil ->
              %{collection: collection,
                count: 1,
                query: query,
                type: type,
                last_queried_at: queried_at}

            # Previous seen unexpected query
            unexpected ->
              %{unexpected |
                count: unexpected.count + 1,
                last_queried_at: queried_at}

          end)
    end)
  end

end
