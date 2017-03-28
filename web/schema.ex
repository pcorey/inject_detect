defmodule InjectDetect.Schema do
  use Absinthe.Schema

  alias InjectDetect.Command.{
    GetStarted,
    RequestSignInLink,
    SignOut,
  }
  alias InjectDetect.CommandHandler
  alias InjectDetect.State

  import Plug.Conn

  import_types InjectDetect.Schema.Types

  def authenticated(resolver) do
    error = {:error, %{error: "Not authenticated", code: :not_authenticated, message: "Not authenticated"}}
    fn
      (_args, %{context: %{user: nil}})     -> error
      (args, info = %{context: %{user: _}}) -> resolver.(args, info)
      (_args, _info)                                -> error
    end
  end

  def resolve_user(_args, %{context: %{user: user}}) do
    {:ok, user}
  end

  def resolve_users(_args, %{context: %{user: user}}) do
    {:ok, state} = InjectDetect.State.get()
    users = for {id, user} <- state.users, do: user
    {:ok, users}
  end

  query do
    field :users, list_of(:user) do
      resolve authenticated &resolve_users/2
    end

    field :user, :user do
      resolve &resolve_user/2
    end
  end

  def handle(command), do: handle(command, fn (_, _) -> {:ok} end)
  def handle(command, resolve) do
    fn
      (args, data) ->
        data = Map.merge(args, data.context)
        case CommandHandler.handle({command, data}) do
          {:ok, _events} -> resolve.(args, data)
          error          -> error
        end
    end
  end

  mutation do
    @desc "Get started"
    field :get_started, type: :user do
      arg :email, non_null(:string)
      resolve handle(:get_stared, fn
        (%{email: email}, _data) ->
          {:ok, State.find_user(:email, email)}
      end)
    end

    field :request_sign_in_link, type: :user do
      arg :email, non_null(:string)
      resolve handle(:request_sign_in_link, fn
        (%{email: email}, _data) ->
          {:ok, State.find_user(:email, email)}
      end)
    end

    field :verify_requested_token, type: :user do
      arg :token, non_null(:string)
      resolve handle(:verify_requested_token, fn
        (%{token: token}, _data) ->
          {:ok, State.find_user(:requested_token, token)}
      end)
    end

    field :sign_out, type: :user do
      resolve authenticated handle(:sign_out, fn
        (_args, %{user_id: user_id}) ->
          {:ok, State.find_user(:id, user_id)}
      end)
    end

  end

end
