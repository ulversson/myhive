defmodule MyHive.Repo.Migrations.AddSlugToChatConversations do
  use Ecto.Migration

  def change do
    alter table(:chat_conversations) do
      add :slug, :string
    end
  end
end
