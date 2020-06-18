defmodule MyHive.Chat.UnsavedAttachment do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Chat.Conversation
  alias MyHive.Accounts.User
  schema "chat_unsaved_attachments" do
    belongs_to :conversation, Conversation
    belongs_to :user, User
    field :filename, :string
    field :filetype, :string
    field :path, :string
    field :size, :integer
    timestamps()
  end

  @doc false
  def changeset(unsaved_attachment, attrs) do
    unsaved_attachment
    |> cast(attrs, [:conversation_id, :path, :size, :user_id, :filename, :filetype])
    |> validate_required([:conversation_id, :user_id, :filename, :filetype])
  end
end
