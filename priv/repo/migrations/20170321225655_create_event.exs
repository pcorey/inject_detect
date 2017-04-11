defmodule InjectDetect.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :data, :map
      add :type, :string
      timestamps()
    end
  end

end
