defmodule InjectDetect.MarkQueryAsHandledTest do
  use ExUnit.Case

  alias InjectDetect.Command.AddCredits
  alias InjectDetect.Command.GetStarted
  alias InjectDetect.Command.IngestQueries
  alias InjectDetect.Command.MarkQueryAsHandled
  alias InjectDetect.Command.ToggleTrainingMode
  alias InjectDetect.State.Application
  alias InjectDetect.State.ExpectedQuery
  alias InjectDetect.State.UnexpectedQuery
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

  test "marks an unexpected query as expected" do
    %GetStarted{email: "email@example.com",
                application_name: "Foo Application",
                application_size: "Medium",
                agreed_to_tos: true}
    |> handle(%{})

    user = User.find(email: "email@example.com")
    application = Application.find(name: "Foo Application")

    %AddCredits{user_id: user.id, credits: 100}
    |> handle(%{user_id: user.id})

    %ToggleTrainingMode{application_id: application.id}
    |> handle(%{user_id: user.id})

    %IngestQueries{application_id: application.id,
                   queries: [%{collection: "users",
                               type: "find",
                               queried_at: ~N[2017-03-28 01:30:00],
                               query: %{"_id" => "string"}}]}
    |> handle(%{})

    query = UnexpectedQuery.find(application.id, type: "find")

    %MarkQueryAsHandled{application_id: application.id,
                         query_id: query.id}
    |> handle(%{user_id: user.id})

    application = Application.find(name: "Foo Application")
    assert length(application.expected_queries) == 0
    assert length(application.unexpected_queries) == 0
  end

end
