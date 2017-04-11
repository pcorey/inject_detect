defmodule InjectDetect.Model.Event do
  use InjectDetect.Web, :model

  schema "events" do
    field :data, :map
    field :stream, :string
    field :type, :string
    field :version, :integer

    timestamps()
  end

end
