defmodule MyHive.EmailInbox.IncomingMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "email_inbox_incoming_messages" do
    field :body_preview, :string
    field :content, :string
    field :conversation_id, :string
    field :web_link, :string
    field :has_attachments, :boolean, default: false
    field :importance, :string
    field :internet_message_id, :string
    field :message_id, :string
    field :parent_folder_id, :string
    field :received_date_time, :naive_datetime
    field :sender, :string
    field :subject, :string
    field :to_recipients, :string

    timestamps()
  end

  @doc false
  def changeset(incoming_message, attrs) do
    incoming_message
    |> cast(attrs, [:message_id, :received_date_time, :has_attachments, :internet_message_id, :subject, :body_preview, :importance, :parent_folder_id, :conversation_id, :content, :sender, :web_link, :to_recipients])
    |> validate_required([:message_id, :received_date_time, :has_attachments, :internet_message_id, :subject, :body_preview, :importance, :parent_folder_id, :conversation_id, :content, :sender, :web_link, :to_recipients])
  end
end
