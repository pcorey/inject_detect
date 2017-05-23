defmodule InjectDetect.State.UnexpectedQuery do

  alias InjectDetect.State

  def new(attrs) do
    attrs
    |> Map.put_new(:seen, 0)
  end

  def find(%{collection: collection, query: query, type: type}) do
    find(collection: collection, query: query, type: type)
  end

  def find(application_id, attrs) do
    State.get()
    |> elem(1)
    |> find(application_id, attrs)
  end

  def find(state, application_id, attrs) when is_list(attrs) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
    |> Lens.key(:unexpected_queries)
    |> Lens.filter(fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end)
    |> Lens.to_list(state)
    |> List.first
  end

  def find(state, application_id, id) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
    |> Lens.key(:unexpected_queries)
    |> Lens.filter(&(&1.id == id))
    |> Lens.to_list(state)
    |> List.first
  end

  def remove(state, application_id, id) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
    |> Lens.key(:unexpected_queries)
    |> Lens.map(state, &Enum.reject(&1, fn query -> query.id == id end))
  end

end
