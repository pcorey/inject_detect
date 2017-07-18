defmodule InjectDetect.Schema do
  use Absinthe.Schema

  alias InjectDetect.Command.{
    AddApplication,
    CreateUser,
    MarkQueryAsExpected,
    MarkQueryAsHandled,
    RegenerateApplicationToken,
    RemoveApplication,
    RemoveExpectedQuery,
    RequestSignInToken,
    UpdatePaymentMethod,
    DeactivateAccount,
    SignOut,
    Subscribe,
    Unsubscribe,
    ToggleAlerting,
    ToggleTrainingMode,
    VerifyRequestedToken,
  }
  alias InjectDetect.CommandHandler
  alias InjectDetect.State
  alias InjectDetect.State.User
  alias InjectDetect.State.Application
  alias InjectDetect.Web.Middleware.Auth

  import_types InjectDetect.Schema.Types

  def resolve_user(_args, %{context: %{user_id: user_id}}) do
    {:ok, User.find(user_id)}
  end
  def resolve_user(_args, _), do: {:ok, nil}

  def resolve_application(%{id: id}, %{context: %{user_id: user_id}}) do
    case application = Application.find(id) do
      %{user_id: ^user_id} -> {:ok, application}
      _                    -> {:error, %{code: :not_found,
                                         error: "Not found",
                                         message: "Not found"}}
    end
  end

  def resolve_unexpected_query(%{id: id}, %{context: %{user_id: user_id}}) do
    unexpected_query = Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:applications)
    |> Lens.all
    |> Lens.key(:queries)
    |> Lens.filter(&(&1.id == id))
    |> Lens.to_list(State.get() |> elem(1))
    |> List.first
    {:ok, unexpected_query}
  end

  query do
    field :user, :user do
      resolve &resolve_user/2
    end

    field :application, :application do
      arg :id, non_null(:string)
      resolve &resolve_application/2
    end

    field :unexpected_query, :application_query do
      arg :id, non_null(:string)
      resolve &resolve_unexpected_query/2
    end
  end

  def handle(command, resolve) do
    fn
      (args, data) ->
        command = struct(command, Map.merge(args, data.context))
        case CommandHandler.handle(command, data.context) do
          {:ok, context} -> {:ok, resolve.(context)}
          error          -> error
        end
    end
  end

  def user(%{user_id: user_id}) do
    User.find(user_id)
  end

  def application(%{application_id: application_id}) do
    Application.find(application_id)
  end

  def unexpected_query(%{application_id: application_id, query_id: query_id}) do
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
    |> Lens.key(:unexpected_queries)
    |> Lens.filter(&(&1.id == query_id))
    |> Lens.to_list(State.get() |> elem(1))
    |> List.first
  end

  mutation do
    field :create_user, type: :user do
      arg :email, non_null(:string)
      arg :application_name, non_null(:string)
      arg :application_size, :string
      arg :agreed_to_tos, non_null(:boolean)
      arg :referral_code, non_null(:string)
      resolve handle(CreateUser, &user/1)
    end

    field :request_sign_in_token, type: :user do
      arg :email, non_null(:string)
      resolve handle(RequestSignInToken, &user/1)
    end

    field :verify_requested_token, type: :user do
      arg :token, non_null(:string)
      resolve handle(VerifyRequestedToken, &user/1)
    end

    field :sign_out, type: :user do
      middleware Auth
      resolve handle(SignOut, &user/1)
    end

    field :subscribe, type: :user do
      arg :user_id, non_null(:string)
      middleware Auth
      resolve handle(Subscribe, &user/1)
    end

    field :unsubscribe, type: :user do
      arg :unsubscribe_token, non_null(:string)
      resolve handle(Unsubscribe, &user/1)
    end

    field :toggle_training_mode, type: :application do
      arg :application_id, non_null(:string)
      middleware Auth
      resolve handle(ToggleTrainingMode, &application/1)
    end

    field :toggle_alerting, type: :application do
      arg :application_id, non_null(:string)
      middleware Auth
      resolve handle(ToggleAlerting, &application/1)
    end

    field :regenerate_application_token, type: :application do
      arg :application_id, non_null(:string)
      middleware Auth
      resolve handle(RegenerateApplicationToken, &application/1)
    end

    field :mark_query_as_expected, type: :application do
      arg :application_id, non_null(:string)
      arg :query_id, non_null(:string)
      middleware Auth
      resolve handle(MarkQueryAsExpected, &application/1)
    end

    field :mark_query_as_handled, type: :application do
      arg :application_id, non_null(:string)
      arg :query_id, non_null(:string)
      middleware Auth
      resolve handle(MarkQueryAsHandled, &application/1)
    end

    field :remove_expected_query, type: :application do
      arg :application_id, non_null(:string)
      arg :query_id, non_null(:string)
      middleware Auth
      resolve handle(RemoveExpectedQuery, &application/1)
    end

    field :add_application, type: :application do
      arg :user_id, non_null(:string)
      arg :application_name, non_null(:string)
      arg :application_size, non_null(:string)
      resolve handle(AddApplication, &application/1)
    end

    field :remove_application, type: :user do
      arg :application_id, non_null(:string)
      resolve handle(RemoveApplication, &user/1)
    end

    field :update_payment_method, type: :user do
      arg :user_id, non_null(:string)
      arg :stripe_token, non_null(:stripe_token_input)
      resolve handle(UpdatePaymentMethod, &user/1)
    end

    field :deactivate_account, type: :user do
      arg :user_id, non_null(:string)
      resolve handle(DeactivateAccount, &user/1)
    end

  end

end
