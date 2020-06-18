defmodule MyHive.Repo.Migrations.CreateChatUnsavedAttachments do
  use Ecto.Migration

  def change do
    create table(:chat_unsaved_attachments) do
      add :conversation_id, :integer
      add :user_id, :integer
      add :filename, :string
      add :filetype, :string
      add :path, :string
      add :size, :integer
      timestamps()
    end

  end
end
