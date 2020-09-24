defmodule MyHive.Repo.Migrations.ChangeBlogAndUnsaveAttachmentSizeToString do
  use Ecto.Migration

  def change do
    alter table(:chat_unsaved_attachments) do
      modify(:size, :string)
    end
    alter table(:blog_attachments) do
      modify(:size, :string)
    end
  end
end
