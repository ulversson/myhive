defmodule MyHive.Repo.Migrations.AddDeletedByToFileManagerItems do
  use Ecto.Migration

  def change do
    alter table(:folders) do
      add :deleted_by, :integer
    end
    alter table(:file_assets) do
      add :deleted_by, :integer
    end
  end
end
