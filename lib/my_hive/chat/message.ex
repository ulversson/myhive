defmodule MyHive.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Encryption.EncryptedField
  alias MyHive.Chat.{Conversation, SeenMessage, MessageReaction}
  @derive {
    Jason.Encoder,
    only: [:content, :user_id, :conversation_id, :user,
      :conversation, :avatar, :inserted_at]
  }
  schema "chat_messages" do
    field :content, EncryptedField
    field :filename, :string
    field :filetype, :string
    field :path, :string
    field :size, :integer
    belongs_to :conversation, Conversation
    belongs_to :user, User

    has_many :seen_messages, SeenMessage
    has_many :message_reactions, MessageReaction

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :filename, :path, :size, :filetype, :conversation_id, :user_id])
    |> validate_required([:content, :conversation_id, :user_id])
  end
end
