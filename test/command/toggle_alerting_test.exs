defmodule InjectDetect.ToggleAlertingTest do
  use ExUnit.Case

  alias InjectDetect.Command.CreateUser
  alias InjectDetect.Command.ToggleAlerting
  alias InjectDetect.State.User
  alias InjectDetect.State.Application

  import InjectDetect.CommandHandler, only: [handle: 2]

  setup tags do
    InjectDetect.State.reset()

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(InjectDetect.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(InjectDetect.Repo, {:shared, self()})
    end
    :ok
  end

  test "toggles training mode" do
    %CreateUser{email: "email@example.com",
                application_name: "Foo Application",
                application_size: "Medium",
                agreed_to_tos: true}
    |> handle(%{})

    user = User.find(email: "email@example.com")
    application = Application.find(name: "Foo Application")

    assert application.alerting == true

    %ToggleAlerting{application_id: application.id}
    |> handle(%{user_id: user.id})

    application = Application.find(name: "Foo Application")
    assert application.alerting == false

    %ToggleAlerting{application_id: application.id}
    |> handle(%{user_id: user.id})

    application = Application.find(name: "Foo Application")
    assert application.alerting == true
  end

end
