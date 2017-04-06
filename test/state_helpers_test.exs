defmodule InjectDetect.StateHelpersTest do
  use ExUnit.Case

  alias InjectDetect.State
  alias InjectDetect.State.Base
  alias InjectDetect.State.User

  test "initializes the base state" do
    assert State.Base.new() == %{users: []}
  end

  test "adds users to the state" do
    state = Base.new()
            |> Base.add_user(id: "123", email: "foo@bar", agreed_to_tos: true)
            |> Base.add_user(id: "456", email: "baz@bar", agreed_to_tos: false)
    assert state == %{users: [%{id: "123",
                                email: "foo@bar",
                                agreed_to_tos: true,
                                applications: []},
                              %{id: "456",
                                email: "baz@bar",
                                agreed_to_tos: false,
                                applications: []}]}
  end

  test "updates a user" do
    state = Base.new()
            |> Base.add_user(id: "123", email: "foo@bar", agreed_to_tos: true)
            |> Base.add_user(id: "456", email: "baz@bar", agreed_to_tos: false)
            |> Base.update_user([id: "123"], fn user -> %{user | email: "hi@bub"} end)
    assert state == %{users: [%{id: "123",
                                email: "hi@bub",
                                agreed_to_tos: true,
                                applications: []},
                              %{id: "456",
                                email: "baz@bar",
                                agreed_to_tos: false,
                                applications: []}]}
  end

  test "adds an application" do
    state = Base.new()
            |> Base.add_user(id: "123", email: "foo@bar", agreed_to_tos: true)
            |> User.add_application([id: "123"], id: "456", name: "Foobar")
    assert state == %{users: [%{id: "123",
                                email: "foo@bar",
                                agreed_to_tos: true,
                                applications: [%{id: "456",
                                                 name: "Foobar"}]}]}
  end

  test "finds an application" do
    state = Base.new()
    |> Base.add_user(id: "123", email: "foo@bar", agreed_to_tos: true)
    |> User.add_application([id: "123"], id: "456", name: "Foobar")

    assert User.find_application(state, id: "456") == %{id: "456",
                                                        name: "Foobar"}
    assert User.find_application(state, "123", id: "456") == %{id: "456",
                                                               name: "Foobar"}
  end

end
