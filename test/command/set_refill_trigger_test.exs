defmodule InjectDetect.SetRefillTriggerTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.Command.SetRefillTrigger
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

  test "sets refill trigger" do
    %GetStarted{email: "email@example.com",
                application_name: "Foo Application",
                application_size: "Medium",
                agreed_to_tos: true}
    |> handle(%{})

    user = User.find(email: "email@example.com")
    user_id = user.id

    assert user.refill_trigger == 1000

    %SetRefillTrigger{user_id: user.id, refill_trigger: 10_000}
    |> handle(%{user_id: user.id})

    user = User.find(email: "email@example.com")
    assert user.refill_trigger == 10_000
  end

end
