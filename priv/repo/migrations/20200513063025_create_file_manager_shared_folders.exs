defmodule MyHive.Repo.Migrations.CreateFileManagerSharedFolders do
  use Ecto.Migration

  def change do
    create table(:file_manager_shared_folders) do
      add :folder_id, :integer
      add :user_id, :integer
      add :shared_user_id, :integer

      timestamps()
    end

  end
end
