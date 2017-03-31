defmodule InjectDetect.InjectDetectTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.Command.SignOut
  alias InjectDetect.State

  import InjectDetect.CommandHandler, only: [handle: 2]

  setup tags do
    InjectDetect.State.reset()

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(InjectDetect.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(InjectDetect.Repo, {:shared, self()})
    end
    :ok
  end

  test "handles a command and updates state" do
    command = %GetStarted{email: "email@example.com",
                          application_name: "Foo Application",
                          application_size: "Medium",
                          agreed_to_tos: true}
    # Verify the resulting context
    {:ok, %{user_id: user_id}} = handle(command, %{})
    assert user_id
    # Verify the user's state
    user = State.user(:email, "email@example.com")
    assert user
    assert user.auth_token
    assert user.email == "email@example.com"
    assert user.id == user_id
  end

  test "handles command errors" do
    command = %GetStarted{email: "email@example.com",
                          application_name: "Foo Application",
                          application_size: "Medium",
                          agreed_to_tos: true}
    handle(command, %{})
    assert {:error, %{code: :email_taken,
                      error: "That email is already being used.",
                      message: "Email taken"}} == handle(command, %{})
  end

  test "signs a user out" do
    handle(%GetStarted{email: "email@example.com",
                       application_name: "Foo Application",
                       application_size: "Medium",
                       agreed_to_tos: true}, %{})
    handle(%SignOut{user_id: State.user(:email, "email@example.com").id},
                  %{user_id: State.user(:email, "email@example.com").id})
    user = State.user(:email, "email@example.com")
    assert user
    refute user.auth_token
  end

  test "can't sign out other user" do
    handle(%GetStarted{email: "email@example.com",
                       application_name: "Foo Application",
                       application_size: "Medium",
                       agreed_to_tos: true}, %{})
    user = State.user(:email, "email@example.com")
    command = %SignOut{user_id: user.id}
    context = %{user_id: 1337}
    assert handle(command, context) == {:error, %{code: :not_authorized,
                                                  error: "Not authorized",
                                                  message: "Not authorized"}}
  end

end
