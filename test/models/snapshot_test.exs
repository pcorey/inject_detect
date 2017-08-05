defmodule InjectDetect.SnapshotTest do
  use InjectDetect.ModelCase

  alias InjectDetect.Model.Snapshot

  @valid_attrs %{event_id: 42, state: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Snapshot.changeset(%Snapshot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Snapshot.changeset(%Snapshot{}, @invalid_attrs)
    refute changeset.valid?
  end
end
