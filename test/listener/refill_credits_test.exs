# defmodule InjectDetect.RefillTokensTest do
#   use ExUnit.Case

#   alias InjectDetect.Command.AddCredits
#   alias InjectDetect.Command.GetStarted
#   alias InjectDetect.Command.IngestQueries
#   alias InjectDetect.Command.SetRefillAmount
#   alias InjectDetect.Command.SetRefillTrigger
#   alias InjectDetect.Command.ToggleTrainingMode
#   alias InjectDetect.Command.TurnOffRefill
#   alias InjectDetect.Command.TurnOnRefill
#   alias InjectDetect.State.User
#   alias InjectDetect.State.Application
#   alias InjectDetect.State.ExpectedQuery
#   alias InjectDetect.State.UnexpectedQuery

#   import InjectDetect.CommandHandler, only: [handle: 2]

#   setup tags do
#     InjectDetect.State.reset()

#     :ok = Ecto.Adapters.SQL.Sandbox.checkout(InjectDetect.Repo)
#     unless tags[:async] do
#       Ecto.Adapters.SQL.Sandbox.mode(InjectDetect.Repo, {:shared, self()})
#     end
#     :ok
#   end


#   test "refills tokens once we hit refill_trigger" do
#     %GetStarted{email: "email@example.com",
#                 application_name: "Foo Application",
#                 application_size: "Medium",
#                 agreed_to_tos: true}
#     |> handle(%{})

#     user = User.find(email: "email@example.com")
#     credits = user.credits
#     application = Application.find(name: "Foo Application")

#     %TurnOnRefill{user_id: user.id}
#     |> handle(%{user_id: user.id})

#     %SetRefillTrigger{user_id: user.id, refill_trigger: credits - 2}
#     |> handle(%{user_id: user.id})

#     %SetRefillAmount{user_id: user.id, refill_amount: 102}
#     |> handle(%{user_id: user.id})

#     %IngestQueries{application_id: application.id,
#                    queries: [%{collection: "users",
#                                type: "find",
#                                queried_at: ~N[2017-03-28 01:30:00],
#                                query: %{"_id" => "string"}},
#                              %{collection: "users",
#                                type: "find",
#                                queried_at: ~N[2017-04-03 11:00:00],
#                                query: %{"_id" => "string"}}
#                             ]}
#     |> handle(%{})

#     user = User.find(email: "email@example.com")
#     assert user.credits == credits + 100

#   end


#   test "doesn't refill when refill is off" do
#     %GetStarted{email: "email@example.com",
#                 application_name: "Foo Application",
#                 application_size: "Medium",
#                 agreed_to_tos: true}
#     |> handle(%{})

#     user = User.find(email: "email@example.com")
#     credits = user.credits
#     application = Application.find(name: "Foo Application")

#     %TurnOffRefill{user_id: user.id}
#     |> handle(%{user_id: user.id})

#     %SetRefillTrigger{user_id: user.id, refill_trigger: credits - 2}
#     |> handle(%{user_id: user.id})

#     %SetRefillAmount{user_id: user.id, refill_amount: 102}
#     |> handle(%{user_id: user.id})

#     %IngestQueries{application_id: application.id,
#                    queries: [%{collection: "users",
#                                type: "find",
#                                queried_at: ~N[2017-03-28 01:30:00],
#                                query: %{"_id" => "string"}},
#                              %{collection: "users",
#                                type: "find",
#                                queried_at: ~N[2017-04-03 11:00:00],
#                                query: %{"_id" => "string"}}
#                             ]}
#     |> handle(%{})

#     user = User.find(email: "email@example.com")
#     assert user.credits == credits - 2

#   end

# end
