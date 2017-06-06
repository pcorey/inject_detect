defmodule InjectDetect.State.ApplicationTest do
  use ExUnit.Case

  alias InjectDetect.State.Application
  alias InjectDetect.State.Base
  alias InjectDetect.State.ExpectedQuery
  alias InjectDetect.State.UnexpectedQuery
  alias InjectDetect.State.User

  test "base application" do
    assert Application.new(%{}) ==
      %{alerting: true,
        expected_queries: [],
        ingesting_queries: true,
        training_mode: true,
        unexpected_queries: []}
    assert Application.new(%{id: 123}) ==
    %{id: 123,
      alerting: true,
      expected_queries: [],
      ingesting_queries: true,
      training_mode: true,
      unexpected_queries: []}
  end

  test "find by id" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    assert Application.find(state, 234) == Application.new(application)
  end

  test "find by name" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    assert Application.find(state, name: "Foo") == Application.new(application)
  end

  test "add expected query" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, collection: "foo", query: %{"_id" => "string"}, type: "find"}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_expected_query(user.id, application.id, query)
    assert Application.find(state, name: "Foo") ==
      %{Application.new(application)
        | expected_queries: [ExpectedQuery.new(query)]}
  end

  test "touch expected query" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, collection: "foo", queried_at: ~D[2017-04-05], query: %{"_id" => "string"}, type: "find"}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_expected_query(user.id, application.id, query)
    |> Application.touch_expected_query(user.id, application.id, query)
    assert Application.find(state, name: "Foo") ==
      %{Application.new(application)
        | expected_queries: [%{ExpectedQuery.new(query) | seen: 1, queried_at: ~D[2017-04-05]}]}
  end

  test "add unexpected query" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, collection: "foo", query: %{"_id" => "string"}, type: "find"}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_unexpected_query(user.id, application.id, query)
    assert Application.find(state, name: "Foo") ==
      %{Application.new(application) | unexpected_queries: [UnexpectedQuery.new(query)]}
  end

  test "touch unexpected query" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, collection: "foo", queried_at: ~D[2017-04-05], query: %{"_id" => "string"}, type: "find"}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_unexpected_query(user.id, application.id, query)
    |> Application.touch_unexpected_query(user.id, application.id, query)
    assert Application.find(state, name: "Foo") ==
      %{Application.new(application)
        | unexpected_queries: [%{UnexpectedQuery.new(query) | seen: 1, queried_at: ~D[2017-04-05]}]}
  end

end
