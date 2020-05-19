defmodule MyHive.Repo.Migrations.AddDefaultToCaseFolderTree do
  use Ecto.Migration

  def change do
    alter table(:saas_case_folder_trees) do
      add :default, :boolean, default: false
    end
  end
end
