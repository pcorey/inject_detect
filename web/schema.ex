defmodule InjectDetect.Schema do
  use Absinthe.Schema

  alias InjectDetect.Command.{
    GetStarted,
    RequestSignInLink,
    SignOut,
  }
  alias InjectDetect.CommandHandler

  import Plug.Conn

  import_types InjectDetect.Schema.Types

  def authenticated(resolver) do
    error = {:error, %{error: "Not authenticated", code: :not_authenticated, message: "Not authenticated"}}
    fn
      (_args, %{context: %{current_user: nil}})     -> error
      (args, info = %{context: %{current_user: _}}) -> resolver.(args, info)
      (_args, _info)                                -> error
    end
  end

  def resolve_current_user(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def resolve_users(_args, %{context: %{current_user: current_user}}) do
    {:ok, state} = InjectDetect.State.get()
    users = for {id, user} <- state.users, do: user
    {:ok, users}
  end

  def get_started(%{email: email}, _info) do
    {:ok, [{_, id, _}]} = CommandHandler.handle(%GetStarted{
      email: email,
      application_name: "Foo Application",
      application_size: "Medium",
      agreed_to_tos: true
    })
    {:ok, %{id: id}}
  end

  query do
    field :users, list_of(:user) do
      resolve authenticated &resolve_users/2
    end

    field :current_user, :user do
      resolve &resolve_current_user/2
    end
  end

  mutation do
    @desc "Get started"
    field :get_started, type: :user do
      arg :email, non_null(:string)
      resolve authenticated &get_started/2
    end

    field :request_sign_in_link, type: :user do
      arg :email, non_null(:string)
      resolve authenticated &RequestSignInLink.resolve/2
    end

    field :sign_out, type: :user do
      resolve authenticated &SignOut.resolve/2
    end
  end

end
