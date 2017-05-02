defmodule InjectDetect.AddCreditsTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.Command.AddCredits
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
    %GetStarted{email: "email@example.com",
                application_name: "Foo Application",
                application_size: "Medium",
                agreed_to_tos: true}
    |> handle(%{})

    user = User.find(email: "email@example.com")
    user_id = user.id

    assert user.credits == 0

    %AddCredits{user_id: user.id, credits: 100_000}
    |> handle(%{user_id: user.id})

    user = User.find(email: "email@example.com")
    assert user.credits == 100_000

    %AddCredits{user_id: user.id, credits: 5_000}
    |> handle(%{user_id: user.id})

    user = User.find(email: "email@example.com")
    assert user.credits == 105_000
  end

end
