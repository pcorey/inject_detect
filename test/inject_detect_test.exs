defmodule InjectDetect.InjectDetectTest do
  use ExUnit.Case

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.Command.IngestQueries
  alias InjectDetect.Command.SignOut
  alias InjectDetect.Command.TurnOffTrainingMode
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

  test "handles a command and updates state" do
    %GetStarted{email: "email@example.com",
                          application_name: "Foo Application",
                          application_size: "Medium",
                          agreed_to_tos: true}
    |> handle(%{})
    # Verify the user's state
    user = User.find(email: "email@example.com")
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
    handle(%SignOut{user_id: User.find(email: "email@example.com").id},
                  %{user_id: User.find(email: "email@example.com").id})
    user = User.find(email: "email@example.com")
    assert user
    refute user.auth_token
  end

  test "can't sign out other user" do
    handle(%GetStarted{email: "email@example.com",
                       application_name: "Foo Application",
                       application_size: "Medium",
                       agreed_to_tos: true}, %{})
    user = User.find(email: "email@example.com")
    command = %SignOut{user_id: user.id}
    context = %{user_id: 1337}
    assert handle(command, context) == {:error, %{code: :not_authorized,
                                                  error: "Not authorized",
                                                  message: "Not authorized"}}
  end

  test "ingests an unexpected query in training mode" do
    setup = [%GetStarted{email: "email@example.com",
                         application_name: "Foo Application",
                         application_size: "Medium",
                         agreed_to_tos: true},
             %GetStarted{email: "email2@example.com",
                         application_name: "Bar Application",
                         application_size: "Large",
                         agreed_to_tos: true}]
    Enum.map(setup, &(handle(&1, %{})))

    application = Application.find(name: "Foo Application")

    %IngestQueries{application_id: application.id,
                   queries: [%{collection: "users",
                               type: "find",
                               queried_at: ~N[2017-03-28 01:30:00],
                               query: %{"_id" => "string"}},
                             %{collection: "users",
                               type: "find",
                               queried_at: ~N[2017-04-03 11:00:00],
                               query: %{"_id" => "string"}},
                             %{collection: "orders",
                               type: "remove",
                               queried_at: ~N[2017-04-03 12:00:00],
                               query: %{"_id" => %{"$gte" => "string"}}}
                            ]}
    |> handle(%{})

    application = Application.find(name: "Foo Application")
    assert Enum.member?(application.expected_queries, %{collection: "users",
                                                        type: "find",
                                                        query: %{"_id" => "string"}})
    assert Enum.member?(application.expected_queries, %{collection: "orders",
                                                        type: "remove",
                                                        query: %{"_id" => %{"$gte" => "string"}}})
  end

  test "ingests an unexpected query out of training mode" do
    setup = [%GetStarted{email: "email@example.com",
                         application_name: "Foo Application",
                         application_size: "Medium",
                         agreed_to_tos: true},
             %GetStarted{email: "email2@example.com",
                         application_name: "Bar Application",
                         application_size: "Large",
                         agreed_to_tos: true}]
    Enum.map(setup, &(handle(&1, %{})))

    user = User.find(email: "email@example.com")
    application = Application.find(name: "Foo Application")

    %TurnOffTrainingMode{application_id: application.id}
    |> handle(%{user_id: user.id})

    %IngestQueries{application_id: application.id,
                   queries: [%{collection: "users",
                               type: "find",
                               queried_at: ~N[2017-03-28 01:30:00],
                               query: %{"_id" => "string"}},
                             %{collection: "users",
                               type: "find",
                               queried_at: ~N[2017-04-03 11:00:00],
                               query: %{"_id" => "string"}},
                             %{collection: "orders",
                               type: "remove",
                               queried_at: ~N[2017-04-03 12:00:00],
                               query: %{"_id" => %{"$gte" => "string"}}}
                            ]}
    |> handle(%{})

    application = Application.find(name: "Foo Application")
    assert Enum.member?(application.unexpected_queries, %{collection: "users",
                                                          type: "find",
                                                          query: %{"_id" => "string"}})
    assert Enum.member?(application.unexpected_queries, %{collection: "orders",
                                                          type: "remove",
                                                          query: %{"_id" => %{"$gte" => "string"}}})
  end

  test "ingests an expected and unexpected queries" do
    %GetStarted{email: "email@example.com",
                application_name: "Foo Application",
                application_size: "Medium",
                agreed_to_tos: true}
    |> handle(%{})

    user = User.find(email: "email@example.com")
    application = Application.find(name: "Foo Application")

    %IngestQueries{application_id: application.id,
                   queries: [%{collection: "users",
                               type: "find",
                               queried_at: ~N[2017-03-28 01:30:00],
                               query: %{"_id" => "string"}}]}
    |> handle(%{})

    %TurnOffTrainingMode{application_id: application.id}
    |> handle(%{user_id: user.id})

    %IngestQueries{application_id: application.id,
                   queries: [%{collection: "users",
                               type: "find",
                               queried_at: ~N[2017-04-03 11:00:00],
                               query: %{"_id" => "string"}},
                             %{collection: "orders",
                               type: "remove",
                               queried_at: ~N[2017-04-03 12:00:00],
                               query: %{"_id" => %{"$gte" => "string"}}}]}
    |> handle(%{})

    application = Application.find(name: "Foo Application")
    assert Enum.member?(application.expected_queries, %{collection: "users",
                                                        type: "find",
                                                        query: %{"_id" => "string"}})
    assert Enum.member?(application.unexpected_queries, %{collection: "orders",
                                                          type: "remove",
                                                          query: %{"_id" => %{"$gte" => "string"}}})
  end

end
