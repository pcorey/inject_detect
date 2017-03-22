defmodule InjectDetect.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :type, :string
      add :aggregate_id, :uuid
      add :data, :map

      timestamps()
    end

  end
end
