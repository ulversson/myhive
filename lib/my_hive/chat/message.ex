defmodule MyHive.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Chat.{Conversation, SeenMessage, MessageReaction}
  @derive {
    Jason.Encoder,
    only: [:content, :user_id, :conversation_id, :user, :conversation, :avatar]
  }
  schema "chat_messages" do
    field :content, :string

    belongs_to :conversation, Conversation
    belongs_to :user, User

    has_many :seen_messages, SeenMessage
    has_many :message_reactions, MessageReaction

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :conversation_id, :user_id])
    |> validate_required([:content, :conversation_id, :user_id])
  end
end
