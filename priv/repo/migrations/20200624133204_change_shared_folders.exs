defmodule MyHive.Repo.Migrations.ChangeSharedFolders do
  use Ecto.Migration

  def change do
    alter table(:file_manager_shared_folders) do
      remove :folder_id, :integer
      add :folder_id, :uuid
    end
  end
end
