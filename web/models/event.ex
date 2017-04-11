defmodule InjectDetect.Model.Event do
  use InjectDetect.Web, :model

  schema "events" do
    field :data, :map
    field :type, :string

    timestamps()
  end

end
