defmodule MyHive.Repo.Migrations.AddSoftDeleteToFolders do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    alter table(:folders) do
      soft_delete_columns()
    end
  end
end
