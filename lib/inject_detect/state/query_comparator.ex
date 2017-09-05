defmodule InjectDetect.State.QueryComparator do

  defp join(nil, second), do: second
  defp join(first, second), do: "#{first}.#{second}"

  def map_to_list(key, map) when is_map(map) do
    Enum.map(map, fn
      {k, v} ->
        case res = map_to_list(join(key, k), v) do
          nil -> [key]
          res -> [key, res]
        end
    end)
  end
  def map_to_list(key, map), do: [key]
  def map_to_list(map), do: map_to_list(nil, map)
                            |> List.flatten
                            |> Enum.uniq

  def distance(a, b) do
    a = map_to_list(a)
    b = map_to_list(b)
    size = MapSet.difference(MapSet.new(b), MapSet.new(a))
    |> MapSet.size
    size
  end

  def get_query(nil), do: nil
  def get_query(%{query: query}), do: query

  def find_similar_query(expected_queries, %{query: query, collection: collection, type: type}) do
    expected_queries
    |> Enum.filter(&(&1.collection == collection && &1.type == type))
    |> Enum.sort(&(distance(&1.query, query) <= distance(&2.query, query)))
    |> List.first
    |> get_query
  end

end
