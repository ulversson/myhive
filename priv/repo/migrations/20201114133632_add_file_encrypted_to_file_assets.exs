defmodule MyHive.Repo.Migrations.AddFileEncryptedToFileAssets do
  use Ecto.Migration

  def change do
    alter table(:file_assets) do
      add :file_encrypted, :boolean, default: false
    end
  end
end
