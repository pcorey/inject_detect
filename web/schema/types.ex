defmodule InjectDetect.Schema.Types do
  use Absinthe.Schema.Notation

  object :expected_query do
    field :collection, :string
    field :query, :string do
      resolve fn
        (expected_query, _, _) ->
          {:ok, Poison.encode!(expected_query[:query])}
      end
    end
    field :type, :string
  end

  object :unexpected_query do
    field :collection, :string
    field :queried_at, :string
    field :query, :string do
      resolve fn
        (unexpected_query, _, _) ->
          {:ok, Poison.encode!(unexpected_query[:query])}
      end
    end
    field :type, :string
  end

  object :application do
    field :id, :id
    field :name, :string
    field :size, :string
    field :token, :string
    field :alerting, :boolean
    field :training_mode, :boolean
    field :unexpected_queries, list_of(:unexpected_query) do
      resolve fn
        (application, _, _) ->
          unexpected_queries = application.unexpected_queries
          |> Enum.map(&InjectDetect.State.UnexpectedQuery.find(application.id, &1))
          {:ok, unexpected_queries}
      end
    end
    field :expected_queries, list_of(:expected_query) do
      resolve fn
        (application, _, _) ->
          IO.puts("resolving #{inspect application}")
          expected_queries = application.expected_queries
          |> Enum.map(&InjectDetect.State.ExpectedQuery.find(application.id, &1))
          {:ok, expected_queries}
      end
    end
  end

  object :user do
    field :id, :id
    field :email, :string
    field :auth_token, :string
    field :applications, list_of(:application) do
      resolve fn
        (user, _, _) ->
          applications = user.applications
          |> Enum.map(&InjectDetect.State.Application.find/1)
          {:ok, applications}
      end
    end
  end

end
