defmodule InjectDetect.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :data, :map
      add :stream, :string
      add :type, :string
      add :version, :integer
      timestamps()
    end
    create unique_index(:events, [:version])
  end

end
