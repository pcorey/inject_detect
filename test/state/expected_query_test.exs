defmodule InjectDetect.State.ExpectedQueryTest do
  use ExUnit.Case

  alias InjectDetect.State.Application
  alias InjectDetect.State.Base
  alias InjectDetect.State.ExpectedQuery
  alias InjectDetect.State.User

  test "base expected query" do
    assert ExpectedQuery.new(%{}) == %{seen: 0}
    assert ExpectedQuery.new(%{id: 123}) == %{id: 123, seen: 0}
  end

  test "find by id" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, query: %{"_id" => "string"}}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_expected_query(application.id, query)
    assert ExpectedQuery.find(state, 234, 345) == ExpectedQuery.new(query)
  end

  test "find by query" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234, name: "Foo"}
    query = %{id: 345, query: %{"_id" => "string"}}
    state = Base.new()
    |> Base.add_user(user)
    |> User.add_application(user.id, application)
    |> Application.add_expected_query(application.id, query)
    assert ExpectedQuery.find(state, 234, query: %{"_id" => "string"}) == ExpectedQuery.new(query)
  end

end
