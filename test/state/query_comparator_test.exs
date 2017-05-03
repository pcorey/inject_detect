defmodule InjectDetect.State.QueryComparatorTest do
  use ExUnit.Case

  import InjectDetect.State.QueryComparator, only: [find_similar_query: 2,
                                                    map_to_list: 1]

  test "turns a map to a list of nested keys" do
    query = %{"_id" => %{"$gte" => "string"}, "foo" => "string", "bar" => %{"baz" => %{"boo" => "string"}}}
    assert map_to_list(query) == [nil, "_id", "_id.$gte", "bar", "bar.baz", "bar.baz.boo", "foo"]

  end

  test "finds simple similar query" do
    expected_queries = [%{query: %{"_id" => "string"}},
                        %{query: %{"foo" => "number"}}]
    query = %{"_id" => %{"$gte" => "string"}}
    assert find_similar_query(expected_queries, query) == %{query: %{"_id" => "string"}}
  end

  test "finds another similar query" do
    expected_queries = [%{query: %{"_id" => "string"}},
                        %{query: %{"foo" => "number"}},
                        %{query: %{"foo" => %{"bar" => "string"}}}]
    query = %{"foo" => %{"bar" => %{"$lt" => "string"}}}
    assert find_similar_query(expected_queries, query) == %{query: %{"foo" => %{"bar" => "string"}}}
  end

end
