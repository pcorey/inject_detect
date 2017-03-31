defmodule InjectDetect.Schema.Types do
  use Absinthe.Schema.Notation

  object :application do
    field :id, :id
    field :application_name, :string
    field :application_size, :string
  end

  object :user do
    field :id, :id
    field :email, :string
    field :auth_token, :string
    field :applications, list_of(:application) do
      resolve fn
        (user, _, _) ->
          {:ok, (for {id, app} <- user.applications, do: app)}
      end
    end
  end

end
