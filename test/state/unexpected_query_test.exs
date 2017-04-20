defmodule InjectDetect.State.UnexpectedQueryTest do
  use ExUnit.Case

  alias InjectDetect.State.Application
  alias InjectDetect.State.Base
  alias InjectDetect.State.UnexpectedQuery
  alias InjectDetect.State.User

  test "base expected query" do
    assert UnexpectedQuery.new(%{}) == %{seen: 1}
    assert Application.new(%{id: 123}) == %{id: 123, seen: 1}
  end

  test "find by id" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, query: %{"_id" => "string"}}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_unexpected_query(application.id, query)
    assert UnexpectedQuery.find(state, 345) == UnexpectedQuery.new(query)
  end

  test "find by query" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, query: %{"_id" => "string"}}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_unexpected_query(application.id, query)
    assert UnexpectedQuery.find(state, query: %{"_id" => "string"}) == UnexpectedQuery.new(query)
  end

end
