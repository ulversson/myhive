defmodule MyHive.Repo.Migrations.CreateShareableDirectoriesFolders do
  use Ecto.Migration

  def change do
    create table(:shareable_directories_folders) do
      add :directory_id, :integer
      add :folder_id, :integer

      timestamps()
    end

  end
end
