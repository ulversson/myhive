defmodule MyHive.Repo.Migrations.AddFolderId do
  use Ecto.Migration

  def change do
    alter table(:sent_emails) do
      add :folder_id, :uuid
    end
  end
end
