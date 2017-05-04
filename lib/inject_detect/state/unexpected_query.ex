defmodule InjectDetect.State.UnexpectedQuery do

  alias InjectDetect.State

  def new(attrs) do
    attrs
    |> Map.put_new(:seen, 0)
  end

  def find(%{collection: collection, query: query, type: type}) do
    find(collection: collection, query: query, type: type)
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
    |> Lens.all
    |> Lens.key(:unexpected_queries)
    |> Lens.filter(fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end)
    |> Lens.to_list(state)
    |> List.first
  end

  def find(state, id) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.all
    |> Lens.key(:unexpected_queries)
    |> Lens.filter(&(&1.id == id))
    |> Lens.to_list(state)
    |> List.first
  end

  def remove(state, id) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.all
    |> Lens.key(:unexpected_queries)
    |> Lens.map(state, &Enum.reject(&1, fn query -> query.id == id end))
  end

end
