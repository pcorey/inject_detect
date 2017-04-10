defmodule InjectDetect.State.Query do

  def to_key(query) do
    %{collection: query[:collection],
      query: query[:query],
      type: query[:type]}
  end

  def is_unexpected?({:ok, state}, application_id, query), do:
    is_unexpected?(state, application_id, query)
  def is_unexpected?(state, application_id, query) do
    get_in(state, [:expected_queries, application_id, to_key(query)]) == nil
  end

  def is_expected?({:ok, state}, application_id, query), do:
    is_expected?(state, application_id, query)
  def is_expected?(state, application_id, query) do
    !is_unexpected?(state, application_id, query)
  end

end
