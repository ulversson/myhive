defmodule MyHive.Repo.Migrations.AddTrackableToSharedFolders do
  use Ecto.Migration

  def change do
    alter table(:folders) do
      add :trackable, :boolean, default: false
    end
  end
end
