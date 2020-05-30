defmodule MyHive.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Chat.ConversationMember
  alias MyHive.Chat.Message
  alias MyHive.Chat.ConversationTitleSlug

  @derive {
    Jason.Encoder,
    only: [:title, :slug, :id]
  }
  schema "chat_conversations" do
    field :title, :string
    field :slug, ConversationTitleSlug.Type
    field :private, :boolean, default: false
    has_many :conversation_members, ConversationMember
    has_many :messages, Message
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
end
