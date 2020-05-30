defmodule MyHive.Repo.Migrations.AddIsPrivateToConversations do
  use Ecto.Migration

  def change do
    alter table(:chat_conversations) do
      add :private, :boolean, default: false
    end
  end
end
