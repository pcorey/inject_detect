defmodule InjectDetect.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :data, :map
      add :stream, :string
      add :stream_version, :integer
      add :type, :string
      add :version, :integer
      timestamps()
    end
    create unique_index(:events, [:version])
    create unique_index(:events, [:stream, :stream_version])
  end

end
