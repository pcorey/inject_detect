defmodule InjectDetect.InjectDetectTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.CommandHandler

  test "handles a command" do
    events = CommandHandler.handle(%GetStarted{
                                     email: "email@example.com",
                                     application_name: "Foo Application",
                                     application_size: "Medium",
                                     agreed_to_tos: true
                                   })
    {:ok, [{_, id, _}]} = events
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
            agreed_to_tos: true
          }
        }
      ]
    }
  end

end
