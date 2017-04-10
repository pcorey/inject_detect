defmodule InjectDetect.State.Query do

  def to_key(query) do
    %{collection: query["collection"],
      query: query["query"],
      type: query["type"]}
  end

  def is_expected?(state, application_id, query) do
    get_in(state, [:expected_queries, application_id, to_key(query)]) != nil
  end

end
