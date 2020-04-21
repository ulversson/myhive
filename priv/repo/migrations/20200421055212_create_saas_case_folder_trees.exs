defmodule MyHive.Repo.Migrations.CreateSaasCaseFolderTrees do
  use Ecto.Migration

  def change do
    create table(:saas_case_folder_trees) do
      add :json_tree, :map
      add :saas_account_id, :integer

      timestamps()
    end

  end
end
