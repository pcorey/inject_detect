defmodule InjectDetect.Event do
  use InjectDetect.Web, :model

  schema "events" do
    field :type, :string
    field :aggregate_id, Ecto.UUID
    field :data, :map

    timestamps()
  end

end
