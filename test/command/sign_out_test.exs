defmodule InjectDetect.SignOutTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.Command.SignOut
  alias InjectDetect.State.User

  import InjectDetect.CommandHandler, only: [handle: 2]

  setup tags do
    InjectDetect.State.reset()

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(InjectDetect.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(InjectDetect.Repo, {:shared, self()})
    end
    :ok
  end

  test "signs a user out" do
    handle(%GetStarted{email: "email@example.com",
                       application_name: "Foo Application",
                       application_size: "Medium",
                       agreed_to_tos: true}, %{})
    user = User.find(email: "email@example.com")
    handle(%SignOut{user_id: user.id},
                  %{user_id: user.id})
    user = User.find(email: "email@example.com")
    assert user
    refute user.auth_token
  end

  test "can't sign out other user" do
    handle(%GetStarted{email: "email@example.com",
                       application_name: "Foo Application",
                       application_size: "Medium",
                       agreed_to_tos: true}, %{})
    user = User.find(email: "email@example.com")
    command = %SignOut{user_id: user.id}
    context = %{user_id: 1337}
    assert handle(command, context) == {:error, %{code: :not_authorized,
                                                  error: "Not authorized",
                                                  message: "Not authorized"}}
  end

end
