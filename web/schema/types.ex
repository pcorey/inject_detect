defmodule InjectDetect.Schema.Types do
  use Absinthe.Schema.Notation

  # object :response do
    
  # end

  object :user do
    field :id, :id
    field :email, :string
    field :auth_token, :string
  end

end
