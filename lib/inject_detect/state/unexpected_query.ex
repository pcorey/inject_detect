defmodule InjectDetect.State.UnexpectedQuery do

  def new(attrs) do
    attrs
    |> Map.put_new(:seen, 0)
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

end
