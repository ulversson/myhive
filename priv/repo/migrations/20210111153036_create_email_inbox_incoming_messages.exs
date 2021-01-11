defmodule MyHive.Repo.Migrations.CreateEmailInboxIncomingMessages do
  use Ecto.Migration

  def change do
    create table(:email_inbox_incoming_messages) do
      add :message_id, :string
      add :received_date_time, :naive_datetime
      add :has_attachments, :boolean, default: false, null: false
      add :internet_message_id, :string
      add :subject, :string
      add :body_preview, :string
      add :importance, :string
      add :parent_folder_id, :string
      add :conversation_id, :string
      add :content, :text
      add :sender, :string
      add :web_link, :string
      add :to_recipients, :string
      add :medico_legal_case_id, :integer
      timestamps()
    end

  end
end
