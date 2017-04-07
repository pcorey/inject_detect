defmodule InjectDetect.Schema.Types do
  use Absinthe.Schema.Notation

  object :application do
    field :id, :id
    field :name, :string
    field :size, :string
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
