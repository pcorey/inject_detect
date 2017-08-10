defmodule InjectDetect.Schema.Types do
  use Absinthe.Schema.Notation

  input_object :stripe_card_input do
    field :id, :string
    field :exp_month, :integer
    field :exp_year, :integer
    field :last4, :string
  end

  input_object :stripe_token_input do
    field :id, :string
    field :card, :stripe_card_input
  end

  object :stripe_card do
    field :id, :string
    field :exp_month, :integer
    field :exp_year, :integer
    field :last4, :string
  end

  object :stripe_token do
    field :id, :string
    field :card, :stripe_card
  end

  object :stripe_invoice do
    field :id, :integer do
      resolve fn (invoice, _, _) -> {:ok, invoice["id"]} end
    end
    field :total, :integer do
      resolve fn (invoice, _, _) -> {:ok, invoice["total"]} end
    end
    field :period_end, :integer do
      resolve fn (invoice, _, _) -> {:ok, invoice["period_end"]} end
    end
    field :starting_balance, :integer do
      resolve fn (invoice, _, _) -> {:ok, invoice["starting_balance"]} end
    end
    # field :ingests, :integer do
    #   resolve fn (invoice, _, _) ->
    #     ingests = invoice["lines"]["data"]
    #     |> Enum.reduce(0, &(&2 + String.to_integer(&1["metadata"]["ingests"] || "0")))
    #     {:ok, ingests}
    #   end
    # end
  end

  object :application_query do
    field :id, :string
    field :collection, :string
    field :queried_at, :string
    field :seen, :integer
    field :expected, :boolean
    field :handled, :boolean
    field :similar_query, :string do
      resolve fn
        (unexpected_query, _, _) ->
          {:ok, Poison.encode!(unexpected_query[:similar_query])}
      end
    end
    field :query, :string do
      resolve fn
        (unexpected_query, _, _) ->
          {:ok, Poison.encode!(unexpected_query[:query])}
      end
    end
    field :type, :string
    field :application, :application do
      resolve fn
        (expected_query, _, _) ->
          {:ok, InjectDetect.State.Application.find(expected_query.application_id)}
      end
    end
  end

  object :application do
    field :id, :id
    field :name, :string
    field :size, :string
    field :token, :string
    field :alerting, :boolean
    field :training_mode, :boolean
    field :queries, list_of(:application_query) do
      resolve fn
        (application, _, _) ->
          {:ok, application.queries}
      end
    end
    field :unexpected_queries, list_of(:application_query) do
      resolve fn
        (application, _, _) -> {:ok, Enum.filter(application.queries, &(&1.expected == false))}
      end
    end
    field :expected_queries, list_of(:application_query) do
      resolve fn
        (application, _, _) -> {:ok, Enum.filter(application.queries, &(&1.expected == true))}
      end
    end
  end

  object :user do
    field :id, :id
    field :email, :string
    field :auth_token, :string
    field :active, :boolean
    field :locked, :boolean
    field :subscribed, :boolean
    field :stripe_token, :stripe_token
    field :applications, list_of(:application)
    field :invoice, :stripe_invoice do
      resolve fn
        (user, _, _) ->
          case Stripe.get_invoice(user.customer_id) do
            {:ok, invoice} ->
              IO.puts("invoice #{inspect invoice}")
              {:ok, invoice}
            _              -> InjectDetect.error("Unable to resolve invoice.")
          end
      end
    end
  end

end
