defmodule MyHive.Repo.Migrations.AddSoftDelToFileAssets do
  use Ecto.Migration
  import Ecto.SoftDelete.Migration

  def change do
    alter table(:file_assets) do
      soft_delete_columns()
    end
  end
end
