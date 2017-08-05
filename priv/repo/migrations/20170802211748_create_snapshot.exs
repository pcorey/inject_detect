defmodule InjectDetect.Repo.Migrations.CreateSnapshot do
  use Ecto.Migration

  def change do
    create table(:snapshots) do
      add :event_id, :integer
      add :state, :binary

      timestamps()
    end

  end
end
