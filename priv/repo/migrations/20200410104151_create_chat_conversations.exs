defmodule MyHive.Repo.Migrations.CreateChatConversations do
  use Ecto.Migration

  def change do
    create table(:chat_conversations) do
      add :title, :binary

      timestamps()
    end

  end
end
