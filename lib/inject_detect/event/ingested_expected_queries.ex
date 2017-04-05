defmodule InjectDetect.Event.IngestedExpectedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedExpectedQueries do

  # defp that_match(collection, query, type) do
  #   fn (:get_and_update, queries, next) ->
  #     queries
  #     |> Enum.map(fn
  #       expected = %{collection: ^collection,
  #                     query: ^query,
  #                     type: ^type}  -> {true, next.(expected)}
  #       expected                  -> {false, {expected, expected}}
  #     end)
  #     |> (fn
  #           queries -> found = queries
  #                     |> Enum.map(&(elem(&1, 0)))
  #                     |> Enum.any?
  #                     case found do
  #                       true  -> Enum.map(queries, &(elem(&1, 1)))
  #                       false -> Enum.map(queries, &(elem(&1, 1))) ++ [next.(nil)]
  #                     end
  #         end).()
  #     |> :lists.unzip
  #   end
  # end

  def apply(event, state) do
    # TODO: Subtract credits
    state

    # event.queries
    # |> Enum.reduce(state, fn
    #   (%{"collection" => collection,
    #      "query" => query,
    #      "queried_at" => queried_at,
    #      "type" => type}, state) ->
    #     update_in(state,
    #       [:users,
    #        Access.all,
    #        :applications,
    #        InjectDetect.State.all_with(id: event.application_id),
    #        :expected_queries,
    #        that_match(collection, query, type)], fn

    #         # New expected query
    #         nil ->
    #           %{collection: collection,
    #             count: 1,
    #             query: query,
    #             type: type,
    #             last_queried_at: queried_at}

    #         # Previous seen expected query
    #         expected ->
    #           %{expected |
    #             count: expected.count + 1,
    #             last_queried_at: queried_at}

    #       end)
    # end)
  end

end
