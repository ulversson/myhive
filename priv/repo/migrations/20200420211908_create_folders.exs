defmodule MyHive.Repo.Migrations.CreateFolders do
  use Ecto.Migration

  def change do
    create table(:folders) do
      add :user_id, :integer
      add :parent_id, :integer
      add :name, :string
      add :folder_type, :string

      timestamps()
    end
    create index(:folders, [:user_id])
    create index(:folders, [:parent_id])


  end
end
