defmodule MyHive.Repo.Migrations.CreateShareableDirectoriesFileAssets do
  use Ecto.Migration

  def change do
    create table(:shareable_directories_file_assets) do
      add :directory_id, :integer
      add :file_asset_id, :integer

      timestamps()
    end

  end
end
