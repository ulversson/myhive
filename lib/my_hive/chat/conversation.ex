defmodule MyHive.Chat.Conversation do
  use Ecto.Schema
  alias MyHive.Encryption.EncryptedField
  import Ecto.{
    Changeset,Query
  }
  alias MyHive.{
    Chat
  }
  alias MyHive.Chat.{
    ConversationMember,
    Message,
    ConversationTitleSlug,
  }

  @derive {
    Jason.Encoder,
    only: [:title, :slug, :id, :private]
  }
  schema "chat_conversations" do
    field :title, EncryptedField
    field :slug, ConversationTitleSlug.Type
    field :private, :boolean, default: false
    has_many :conversation_members, ConversationMember
    has_many :messages, Message
    has_many :seen_messages, through: [:messages, :seen_messages]
    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:title, :private])
    |> validate_required([:title])
    |> ConversationTitleSlug.maybe_generate_slug
    |> ConversationTitleSlug.unique_constraint
  end

  def new_message_count(conv, user_id) do
    Chat.not_seen_messages(conv.id, user_id)
  end

  def opponent_messages(messages) do
    messages |> where([m], m)
  end
end
