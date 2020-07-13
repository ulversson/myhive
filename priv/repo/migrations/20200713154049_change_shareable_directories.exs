defmodule MyHive.Repo.Migrations.ChangeShareableDirectories do
  use Ecto.Migration

  def change do
    alter table(:shareable_directories) do
      remove :id, :integer
      add :id, :binary
    end
    alter table(:shareable_directories_folders) do
      remove :id, :integer
      add :id, :binary
      remove :directory_id, :integer
      add :directory_id, :binary
      remove :folder_id, :integer
      add :folder_id, :binary
    end
    alter table(:shareable_directories_file_assets) do
      remove :id, :integer
      add :id, :binary
      remove :directory_id, :integer
      add :directory_id, :binary
      remove :file_asset_id, :integer
      add :file_asset_id, :binary
    end
    alter table(:shareable_authorizations) do
      remove :shareable_directory_id, :integer
      add :shareable_directory_id, :binary
    end
  end
end
