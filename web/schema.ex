defmodule InjectDetect.Schema do
  use Absinthe.Schema

  alias InjectDetect.Command.GetStarted
  alias InjectDetect.CommandHandler

  import_types InjectDetect.Schema.Types

  def resolve_users(_args, _info) do
    {:ok, state} = InjectDetect.State.get()
    users = case get_in(state, [:users]) do
      nil -> []
      users -> users
    end
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
      resolve &resolve_users/2
    end
  end

  mutation do
    @desc "Get started"
    field :get_started, type: :user do
      arg :email, non_null(:string)

      resolve &get_started/2
    end
  end

end
