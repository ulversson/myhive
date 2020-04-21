defmodule MyHive.Repo.Migrations.AddNameToCaseFolderTrees do
  use Ecto.Migration

  def change do
    alter table(:saas_case_folder_trees) do
      add :name, :string
    end
  end
end
