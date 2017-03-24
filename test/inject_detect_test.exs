defmodule InjectDetect.InjectDetectTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.CommandHandler

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(InjectDetect.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(InjectDetect.Repo, {:shared, self()})
    end
    :ok
  end

  test "handles a command" do
    events = CommandHandler.handle(%GetStarted{
                                     email: "email@example.com",
                                     application_name: "Foo Application",
                                     application_size: "Medium",
                                     agreed_to_tos: true
                                   })

    state = InjectDetect.State.get()
    IO.inspect(state)
    errors = CommandHandler.handle(%GetStarted{
                                     email: "email@example.com",
                                     application_name: "Foo Application",
                                     application_size: "Medium",
                                     agreed_to_tos: true
                                   })
    assert errors == {:error, :email_taken}

    {:ok, [{_, id, %{token: token}}]} = events
    assert events == {
      :ok,
      [
        {
          :got_started,
          id,
          %{
            id: id,
            email: "email@example.com",
            application_name: "Foo Application",
            application_size: "Medium",
            agreed_to_tos: true,
            token: token
          }
        }
      ]
    }

    [events] = InjectDetect.Event
    |> InjectDetect.Repo.all
    |> Enum.to_list

    assert events.aggregate_id == id
    assert events.type == "got_started"
    assert events.data == %{
      "id" => id,
      "email" => "email@example.com",
      "application_name" => "Foo Application",
      "application_size" => "Medium",
      "agreed_to_tos" => true,
      "token" => token
    }

    InjectDetect.State.get()

    CommandHandler.handle(%GetStarted{
      email: "email2@example.com",
      application_name: "Foo Application",
      application_size: "Medium",
      agreed_to_tos: true
    })

    InjectDetect.State.get()
    InjectDetect.State.get()
    state = InjectDetect.State.get()
    IO.inspect(state)
  end

end
