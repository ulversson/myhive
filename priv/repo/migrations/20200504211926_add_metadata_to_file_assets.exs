defmodule MyHive.Repo.Migrations.AddMetadataToFileAssets do
  use Ecto.Migration

  def change do
    alter table(:file_assets) do
      add :metadata, :map
    end
  end
end
