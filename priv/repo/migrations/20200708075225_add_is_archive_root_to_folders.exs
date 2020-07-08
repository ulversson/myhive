defmodule MyHive.Repo.Migrations.AddIsArchiveRootToFolders do
  use Ecto.Migration

  def change do
    alter table(:folders) do
      add :archive_root, :boolean, default: false
    end
  end
end
