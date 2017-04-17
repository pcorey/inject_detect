defmodule InjectDetect.GetStartedTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.State.Application
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

  test "gets a user started" do
    %GetStarted{email: "email@example.com",
                          application_name: "Foo Application",
                          application_size: "Medium",
                          agreed_to_tos: true}
    |> handle(%{})
    user = User.find(email: "email@example.com")
    assert user
    assert user.auth_token
    assert user.email == "email@example.com"
    assert user.id

    application = Application.find(name: "Foo Application")
    assert application
    assert application.size == "Medium"
  end

  test "gets multiple users started" do
    %GetStarted{email: "email@example.com",
                application_name: "Foo Application",
                application_size: "Medium",
                agreed_to_tos: true}
    |> handle(%{})
    %GetStarted{email: "email2@example.com",
                application_name: "Bar Application",
                application_size: "Small",
                agreed_to_tos: true}
    |> handle(%{})
    assert User.find(email: "email@example.com")
    assert User.find(email: "email2@example.com")
    assert Application.find(name: "Foo Application")
    assert Application.find(name: "Bar Application")
  end

  test "prevents duplicate emails" do
    command = %GetStarted{email: "email@example.com",
                          application_name: "Foo Application",
                          application_size: "Medium",
                          agreed_to_tos: true}
    handle(command, %{})
    assert {:error, %{code: :email_taken,
                      error: "That email is already being used.",
                      message: "Email taken"}} == handle(command, %{})
  end

end
