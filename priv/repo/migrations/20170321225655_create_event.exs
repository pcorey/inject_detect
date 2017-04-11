defmodule InjectDetect.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :data, :map
      add :stream, :string
      add :stream_head, :integer
      add :type, :string
      add :version, :integer
      timestamps()
    end
    create unique_index(:events, [:stream, :stream_head])
  end

end
