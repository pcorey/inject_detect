defmodule InjectDetect.RemoveApplicationTest do
  use ExUnit.Case

  alias InjectDetect.Command.AddApplication
  alias InjectDetect.Command.RemoveApplication
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

  test "removes an application" do
    %GetStarted{email: "email@example.com",
                application_name: "Foo Application",
                application_size: "Medium",
                agreed_to_tos: true}
                |> handle(%{})

    user = User.find(email: "email@example.com")

    %AddApplication{user_id: user.id,
                    application_name: "Bar Application",
                    application_size: "Small"}
                    |> handle(%{user_id: user.id})

    application = Application.find(name: "Foo Application")

    %RemoveApplication{application_id: application.id}
    |> handle(%{user_id: user.id})

    application = Application.find(name: "Foo Application")
    refute application

    application = Application.find(name: "Bar Application")
    assert application
  end

end
