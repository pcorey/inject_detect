defmodule InjectDetect.State.Application do

  alias InjectDetect.State
  alias InjectDetect.State.ExpectedQuery
  alias InjectDetect.State.UnexpectedQuery

  def new(attrs) do
    attrs
    |> Map.put_new(:alerting, true)
    |> Map.put_new(:ingesting_queries, true)
    |> Map.put_new(:training_mode, true)
    |> Map.put_new(:queries, [])
  end

  def find(attrs) do
    State.get()
    |> elem(1)
    |> find(attrs)
  end

  def find(state, attrs) when is_list(attrs) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.filter(fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end)
    |> Lens.to_list(state)
    |> List.first
  end

  def find(state, id) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == id))
    |> Lens.to_list(state)
    |> List.first
  end

  def add_expected_query(state, user_id, application_id, query) do
    application_lens(user_id, application_id)
    |> Lens.key(:queries)
    |> Lens.map(state, &([ExpectedQuery.new(query) | &1]))
  end

  def touch_expected_query(state, user_id, application_id, query) do
    application_lens(user_id, application_id)
    |> Lens.key(:queries)
    |> Lens.filter(&(&1.id == query.id))
    |> Lens.map(state, &(%{&1 | queried_at: query.queried_at,
                                seen: &1.seen + 1}))
  end

  def add_unexpected_query(state, user_id, application_id, query) do
    application_lens(user_id, application_id)
    |> Lens.key(:queries)
    |> Lens.map(state, &([UnexpectedQuery.new(query) | &1]))
  end

  def touch_unexpected_query(state, user_id, application_id, query) do
    application_lens(user_id, application_id)
    |> Lens.key(:queries)
    |> Lens.filter(&(&1.id == query.id))
    |> Lens.map(state, &(%{&1 | queried_at: query.queried_at,
                                seen: &1.seen + 1,
                                handled: false}))
  end

  defp application_lens(user_id, application_id) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
  end

end
