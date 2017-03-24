defmodule InjectDetect.Schema.Types do
  use Absinthe.Schema.Notation

  # object :response do
    
  # end

  object :user do
    field :id, :id
    field :email, :string
  end

end
