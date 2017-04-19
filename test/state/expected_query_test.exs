defmodule InjectDetect.State.ExpectedQueryTest do
  use ExUnit.Case

  alias InjectDetect.State.Application
  alias InjectDetect.State.Base
  alias InjectDetect.State.ExpectedQuery
  alias InjectDetect.State.User

  test "base expected query" do
    assert ExpectedQuery.new(%{}) == %{seen: 1}
    assert Application.new(%{id: 123}) == %{id: 123, seen: 1}
  end

  test "find by id" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, query: %{"_id" => "string"}}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_expected_query(application.id, query)
    assert ExpectedQuery.find(state, 345) == ExpectedQuery.new(query)
  end

  test "find by query" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, query: %{"_id" => "string"}}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_expected_query(application.id, query)
    assert ExpectedQuery.find(state, query: %{"_id" => "string"}) == ExpectedQuery.new(query)
  end

  # test "find by name" do
  #   user = %{id: 123, email: "foo@bar.com"}
  #   application = %{id: 234, name: "Foo"}
  #   state = Base.new()
  #   |> Base.add_user(user)
  #   |> User.add_application(user.id, application)
  #   assert Application.find(state, name: "Foo") == Application.new(application)
  # end

  # test "add expected query" do
  #   user = %{id: 123, email: "foo@bar.com"}
  #   application = %{id: 234, name: "Foo"}
  #   query = %{id: 345, collection: "foo", query: %{"_id" => "string"}, type: "find"}
  #   state = Base.new()
  #   |> Base.add_user(user)
  #   |> User.add_application(user.id, application)
  #   |> Application.add_expected_query(application.id, query)
  #   assert Application.find(state, name: "Foo") ==
  #     %{Application.new(application)
  #       | expected_queries: [ExpectedQuery.new(query)]}
  # end

  # test "touch expected query" do
  #   user = %{id: 123, email: "foo@bar.com"}
  #   application = %{id: 234, name: "Foo"}
  #   query = %{id: 345, collection: "foo", query: %{"_id" => "string"}, type: "find"}
  #   state = Base.new()
  #   |> Base.add_user(user)
  #   |> User.add_application(user.id, application)
  #   |> Application.add_expected_query(application.id, query)
  #   |> Application.touch_expected_query(application.id, query)
  #   assert Application.find(state, name: "Foo") ==
  #     %{Application.new(application)
  #       | expected_queries: [%{ExpectedQuery.new(query)
  #                              | seen: 2}]}
  # end

  # test "add unexpected query" do
  #   user = %{id: 123, email: "foo@bar.com"}
  #   application = %{id: 234, name: "Foo"}
  #   query = %{id: 345, collection: "foo", query: %{"_id" => "string"}, type: "find"}
  #   state = Base.new()
  #   |> Base.add_user(user)
  #   |> User.add_application(user.id, application)
  #   |> Application.add_unexpected_query(application.id, query)
  #   assert Application.find(state, name: "Foo") ==
  #     %{Application.new(application)
  #       | unexpected_queries: [UnexpectedQuery.new(query)]}
  # end

  # test "touch unexpected query" do
  #   user = %{id: 123, email: "foo@bar.com"}
  #   application = %{id: 234, name: "Foo"}
  #   query = %{id: 345, collection: "foo", query: %{"_id" => "string"}, type: "find"}
  #   state = Base.new()
  #   |> Base.add_user(user)
  #   |> User.add_application(user.id, application)
  #   |> Application.add_unexpected_query(application.id, query)
  #   |> Application.touch_unexpected_query(application.id, query)
  #   assert Application.find(state, name: "Foo") ==
  #     %{Application.new(application)
  #       | unexpected_queries: [%{UnexpectedQuery.new(query)
  #                                | seen: 2}]}
  # end

end
