defmodule InjectDetect.State.BaseTest do
  use ExUnit.Case

  alias InjectDetect.State.Base
  alias InjectDetect.State.User

  test "base state" do
    assert Base.new() == %{users: []}
  end

  test "adds a user" do
    user = %{id: 123, email: "foo@bar.com"}
    state = Base.add_user(Base.new(), user)
    assert state == %{users: [User.new(user)]}
  end

end
