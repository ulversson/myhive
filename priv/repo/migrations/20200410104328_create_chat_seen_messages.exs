defmodule MyHive.Repo.Migrations.CreateChatSeenMessages do
  use Ecto.Migration

  def change do
    create table(:chat_seen_messages) do
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :message_id, references(:chat_messages, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:chat_seen_messages, [:user_id, :message_id])
    create index(:chat_seen_messages, [:user_id])
    create index(:chat_seen_messages, [:message_id])
  end
end