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

  test "lenses" do
    state = %{
      users: [
        %{
          id: 123,
          applications: [
            %{
              id: 234,
              name: "Foo",
              expected_queries: [
                %{
                  id: 345,
                  query: %{"_id" => "string"},
                  collection: "foo",
                  type: "find"
                },
                %{
                  id: 456,
                  query: %{"_id" => "number"},
                  collection: "foo",
                  type: "find"
                }
              ],
              unexpected_queries: [
                %{
                  id: 567,
                  query: %{"_id" => %{"$gte" => "string"}},
                  collection: "foo",
                  type: "find",
                  queried_at: "1999",
                  seen: 1
                },
                %{
                  id: 678,
                  query: %{"_id" => %{"$lt" => "string"}},
                  collection: "foo",
                  type: "find",
                  queried_at: "2000",
                  seen: 1
                }
              ]
            }
          ]
        }
      ]
    }
    lens = Lens.key(:users)
           |> Lens.filter(&(&1.id == 123))
           |> Lens.key(:applications)
           |> Lens.all
           |> Lens.key(:unexpected_queries)
           |> Lens.filter(&(&1.id == 666))
           |> Lens.key(:id)
    # assert Lens.get(lens, state).seen == 1
    IO.inspect Lens.to_list(lens, state) |> List.first

    state = Lens.map(lens, state, fn
      (query = %{seen: seen}) -> %{query | seen: seen + 1}
      _ -> IO.puts("_")
           %{id: 666, foo: "bar", seen: 1}
    end)
    IO.inspect Lens.get(lens, state)
    # assert Lens.get(lens, state).seen == 2
    # IO.inspect Lens.get(lens, state)
    # IO.inspect(state)
  end

end
