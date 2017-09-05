defmodule InjectDetect.State.QueryComparatorTest do
  use ExUnit.Case

  import InjectDetect.State.QueryComparator, only: [find_similar_query: 2,
                                                    map_to_list: 1]

  test "turns a map to a list of nested keys" do
    query = %{"_id" => %{"$gte" => "string"}, "foo" => "string", "bar" => %{"baz" => %{"boo" => "string"}}}
    assert map_to_list(query) == [nil, "_id", "_id.$gte", "bar", "bar.baz", "bar.baz.boo", "foo"]

  end

  test "finds simple similar query" do
    expected_queries = [%{collection: "a", type: "find", query: %{"_id" => "string"}},
                        %{collection: "a", type: "find", query: %{"foo" => "number"}}]
    query = %{collection: "a", type: "find", query: %{"_id" => %{"$gte" => "string"}}}
    assert find_similar_query(expected_queries, query) == %{"_id" => "string"}
  end

  test "finds another similar query" do
    expected_queries = [%{collection: "a", type: "find", query: %{"_id" => "string"}},
                        %{collection: "a", type: "find", query: %{"foo" => "number"}},
                        %{collection: "a", type: "find", query: %{"foo" => %{"bar" => "string"}}}]
    query = %{collection: "a", type: "find", query: %{"foo" => %{"bar" => %{"$lt" => "string"}}}}
    assert find_similar_query(expected_queries, query) == %{"foo" => %{"bar" => "string"}}
  end

  test "finds string similar query" do
    expected_queries = [%{collection: "a", type: "find", query: %{"_id" => "string"}},
                        %{collection: "a", type: "find", query: "string"}]
    query = %{collection: "a", type: "find", query: %{"_id" => %{"$gte" => "string"}}}
    assert find_similar_query(expected_queries, query) == %{"_id" => "string"}
  end

end
