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

  object :stripe_charge do
    field :id, :string
    field :amount, :integer
    field :description, :string
    field :created, :integer
  end

  object :query do
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
    field :queries, list_of(:query)
    field :unexpected_queries, list_of(:query) do
      resolve fn
        (application, _, _) -> {:ok, Enum.filter(application.queries, &(&1.expected == false))}
      end
    end
    field :expected_queries, list_of(:query) do
      resolve fn
        (application, _, _) -> {:ok, Enum.filter(application.queries, &(&1.expected == true))}
      end
    end
  end

  object :user do
    field :id, :id
    field :email, :string
    field :auth_token, :string
    field :credits, :integer
    field :refill, :boolean
    field :refill_trigger, :integer
    field :refill_amount, :integer
    field :stripe_token, :stripe_token
    field :applications, list_of(:application)
    field :charges, list_of(:stripe_charge) do
      resolve fn
        (user, _, _) ->
          case Stripe.get_charges(user.customer_id) do
            {:ok, charges} -> {:ok, charges}
            _ -> InjectDetect.error("Unable to resolve charges.")
          end
      end
    end
  end

end
