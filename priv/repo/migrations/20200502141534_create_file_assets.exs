defmodule MyHive.Repo.Migrations.CreateFileAssets do
  use Ecto.Migration

  def change do
    create table(:file_assets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :folder_id, :uuid
      add :name, :binary
      add :filetype, :binary
      add :caption, :binary
      add :size, :integer
      add :uid, :binary
      add :path, :binary
      timestamps()
    end
    create(index(:file_assets, [:folder_id]))
  end
end
