defmodule InjectDetect.InjectDetectTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.Command.SignOut
  alias InjectDetect.Event.GotStarted
  alias InjectDetect.State

  import InjectDetect.CommandHandler, only: [handle: 1]

  setup tags do
    # Restart state process to start fresh
    InjectDetect.State
    |> Process.whereis
    |> Process.exit(:kill)

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
    # Verify the resulting events
    {:ok, [got_started = %event{}]} = handle(command)
    assert event == GotStarted
    assert got_started.auth_token
    assert got_started.email == "email@example.com"
    assert got_started.user_id
    # Verify the user's state
    user = State.user(:email, "email@example.com")
    assert user
    assert user.auth_token
    assert user.email == "email@example.com"
    assert user.id
  end

  test "handles command errors" do
    command = %GetStarted{email: "email@example.com",
                          application_name: "Foo Application",
                          application_size: "Medium",
                          agreed_to_tos: true}
    handle(command)
    assert {:error, :email_taken} == handle(command)
  end

  test "signs a user out" do
    handle(%GetStarted{email: "email@example.com",
                       application_name: "Foo Application",
                       application_size: "Medium",
                       agreed_to_tos: true})
    handle(%SignOut{user_id: State.user(:email, "email@example.com").id})
    user = State.user(:email, "email@example.com")
    assert user
    refute user.auth_token
  end

end
