defmodule MyHive.Repo.Migrations.AddDescriptionToFolders do
  use Ecto.Migration

  def change do
    alter table(:folders) do
      add :description, :text
    end
  end
end
