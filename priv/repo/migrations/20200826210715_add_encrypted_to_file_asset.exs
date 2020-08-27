defmodule MyHive.Repo.Migrations.AddEncryptedToFileAsset do
  use Ecto.Migration

  def change do
    alter table(:file_assets) do
      add :encrypted, :boolean, default: false
    end
  end
end
