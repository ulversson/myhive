defmodule MyHive.Repo.Migrations.CreateFileAssets do
  use Ecto.Migration

  def change do
    create table(:file_assets) do
      add :folder_id, :integer
      add :name, :string
      add :filetype, :string
      add :caption, :string
      add :size, :integer
      add :uid, :string
      add :path, :string
      timestamps()
    end
    create(index(:file_assets, [:folder_id]))
  end
end
