defmodule InjectDetect.Model.Snapshot do
  use InjectDetect.Web, :model

  schema "snapshots" do
    field :event_id, :integer
    field :state, :binary

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:event_id, :state])
    |> validate_required([:event_id, :state])
  end
end
