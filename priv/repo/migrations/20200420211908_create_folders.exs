defmodule MyHive.Repo.Migrations.CreateFolders do
  use Ecto.Migration

  def change do
    create table(:folders, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :integer
      add :parent_id, :uuid
      add :name, :binary
      add :folder_type, :binary

      timestamps()
    end
    create index(:folders, [:user_id])
    create index(:folders, [:parent_id])


  end
end
