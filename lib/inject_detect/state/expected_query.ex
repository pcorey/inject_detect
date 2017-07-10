defmodule InjectDetect.State.ExpectedQuery do


  alias InjectDetect.State


  def new(attrs) do
    attrs
    |> Map.put_new(:seen, 0)
    |> Map.put_new(:expected, true)
    |> Map.put_new(:handled, false)
  end


  def find(user_id, application_id, attrs) do
    State.get()
    |> elem(1)
    |> find(user_id, application_id, attrs)
  end

  def find(state, user_id, application_id, %{collection: collection, query: query, type: type}) do
    find(state, application_id, collection: collection, query: query, type: type)
  end

  def find(state, user_id, application_id, attrs) when is_list(attrs) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
    |> Lens.key(:queries)
    |> Lens.filter(fn query -> query.expected && Enum.all?(attrs, fn {k, v} -> query[k] == v end) end)
    |> Lens.to_list(state)
    |> List.first
  end

  def find(state, user_id, application_id, id) do
    find(state, user_id, application_id, id: id)
  end


  def remove(state, user_id, application_id, id) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
    |> Lens.key(:queries)
    |> Lens.map(state, &Enum.reject(&1, fn query -> query.expected && query.id == id end))
  end

end
