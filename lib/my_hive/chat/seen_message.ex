defmodule MyHive.Chat.SeenMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
  alias MyHive.Chat.Message
  schema "chat_seen_messages" do
    belongs_to :user, User
    belongs_to :message, Message

    timestamps()
  end

  @doc false
  def changeset(seen_message, attrs) do
    seen_message
    |> cast(attrs, [:user_id, :message_id])
    |> validate_required([:user_id, :message_id])
    end
end

