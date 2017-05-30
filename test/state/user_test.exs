defmodule InjectDetect.State.UserTest do
  use ExUnit.Case

  alias InjectDetect.State.Application
  alias InjectDetect.State.Base
  alias InjectDetect.State.User

  test "base user" do
    assert User.new(%{}) == %{applications: [],
                              credits: 0,
                              refill: true,
                              refill_trigger: 1_000,
                              refill_amount: 10_000,
                              stripe_token: nil}
    assert User.new(%{id: 123}) == %{id: 123,
                                     applications: [],
                                     credits: 0,
                                     refill: true,
                                     refill_trigger: 1_000,
                                     refill_amount: 10_000,
                                     stripe_token: nil}
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
