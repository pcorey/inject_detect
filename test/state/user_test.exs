defmodule InjectDetect.State.UserTest do
  use ExUnit.Case

  alias InjectDetect.State.Application
  alias InjectDetect.State.Base
  alias InjectDetect.State.User

  test "base user" do
    assert User.new(%{}) == %{applications: [],
                              subscribed: true,
                              active: true,
                              locked: false,
                              ingests_pending_invoice: 0}
    assert User.new(%{id: 123}) == %{id: 123,
                                     applications: [],
                                     subscribed: true,
                                     active: true,
                                     locked: false,
                                     ingests_pending_invoice: 0}
  end

  test "find by id" do
    user = %{id: 123, email: "foo@bar.com"}
    state = Base.add_user(Base.new(), user)
    assert User.find(state, 123) == User.new(user)
  end

  test "find by email" do
    user = %{id: 123, email: "foo@bar.com"}
    state = Base.add_user(Base.new(), user)
    assert User.find(state, email: "foo@bar.com") == User.new(user)
  end

  test "adds an application" do
    user = %{id: 123, email: "foo@bar.com"}
    application = %{id: 234}
    state = Base.add_user(Base.new(), user)
    assert User.add_application(state, 123, application) ==
      %{users: [%{User.new(user) | applications: [Application.new(%{id: 234})]}]}
  end

end
