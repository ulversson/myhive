defmodule MyHive.Chat do
  import Ecto.Query, warn: false
  alias MyHive.{
    Repo,
    Accounts
  }

  alias MyHive.Accounts.User
  alias MyHive.Chat.{
    Conversation,
    ConversationMember,
    Message,
    Emoji,
    MessageReaction
  }

  def create_conversation(attrs \\ %{}) do
    %Conversation{}
    |> Conversation.changeset(attrs)
    |> Repo.insert()
  end

  def get_lobby() do
    conv_by_name("myhive-lobby")
  end

  def conv_by_name(name) do
    Repo.get_by(Conversation, slug: name)
  end

  def add_to_lobby(user_id) do
    lobby = get_lobby()
    create_conversation_member(%{
      conversation_id: lobby.id, user_id: user_id, owner: false
    })
  end

  def conversation_members(except_id, conv) do
    query = from u in User,
      join: c in assoc(u, :conversations),
      preload: [:conversations],
      where: c.slug == ^conv,
      where: u.id != ^except_id,
      select: u
    Repo.all(query)
  end

  def private_conv_between(user_id, opponent_id) do
    from co in Conversation,
     where: co.private == true,
     join: cm in assoc(co, :conversation_members),
     where: cm.conversation_id == co.id,
     where: cm.user_id == ^user_id,
     join: cm2 in assoc(co, :conversation_members),
     where: cm2.user_id == ^opponent_id,
     where: cm.user_id in [^user_id, ^opponent_id ],
     group_by: co.id
  end

  def private_conv_get_or_create(user_id, opponent_id) do
    user = Accounts.get_user!(user_id)
    opponent = Accounts.get_user!(opponent_id)
    private_conv =
      case Repo.one(private_conv_between(user_id, opponent_id)) do
        nil ->
          {:ok, conv} =
            Repo.transaction(fn ->
              {:ok,conv} = create_conversation(%{
                title: "Private Chat between #{user.first_name} and #{opponent.first_name}",
                private: true
              })
              create_conversation_member(%{conversation_id: conv.id,
                user_id: user_id, owner: false})
              create_conversation_member(%{conversation_id: conv.id,
                user_id: opponent_id, owner: false})
              conv
            end)
          conv
        found ->
        Repo.preload(found, [{:conversation_members, :user}])
      end
    private_conv
  end

  def messages_for_conversation(conv_id) do
    query = from m in Message,
      where: m.conversation_id == ^conv_id,
      limit: 100,
      preload: [:user],
      order_by: [:id]
    Repo.all(query)
  end

  def update_conversation(%Conversation{} = conversation, attrs) do
    conversation
    |> Conversation.changeset(attrs)
    |> Repo.update()
  end

  def delete_conversation(%Conversation{} = conversation) do
    Repo.delete(conversation)
  end

  def change_conversation(%Conversation{} = conversation) do
    Conversation.changeset(conversation, %{})
  end

  def get_conversation_member!(id), do: Repo.get!(ConversationMember, id)

  def create_conversation_member(attrs \\ %{}) do
    %ConversationMember{}
    |> ConversationMember.changeset(attrs)
    |> Repo.insert()
  end

  def update_conversation_member(%ConversationMember{} = conversation_member, attrs) do
    conversation_member
    |> ConversationMember.changeset(attrs)
    |> Repo.update()
  end

  def delete_conversation_member(%ConversationMember{} = conversation_member) do
    Repo.delete(conversation_member)
  end

  def change_conversation_member(%ConversationMember{} = conversation_member) do
    ConversationMember.changeset(conversation_member, %{})
  end

  def list_chat_messages do
    Repo.all(Message)
  end

  def get_message!(id), do: Repo.get!(Message, id)

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end

  def create_emoji(attrs \\ %{}) do
    %Emoji{}
    |> Emoji.changeset(attrs)
    |> Repo.insert()
  end

  def update_emoji(%Emoji{} = emoji, attrs) do
    emoji
    |> Emoji.changeset(attrs)
    |> Repo.update()
  end

  def delete_emoji(%Emoji{} = emoji) do
    Repo.delete(emoji)
  end

  def change_emoji(%Emoji{} = emoji) do
    Emoji.changeset(emoji, %{})
  end

  def create_message_reaction(attrs \\ %{}) do
    %MessageReaction{}
    |> MessageReaction.changeset(attrs)
    |> Repo.insert()
  end

  def update_message_reaction(%MessageReaction{} = message_reaction, attrs) do
    message_reaction
    |> MessageReaction.changeset(attrs)
    |> Repo.update()
  end

  def delete_message_reaction(%MessageReaction{} = message_reaction) do
    Repo.delete(message_reaction)
  end

  def change_message_reaction(%MessageReaction{} = message_reaction) do
    MessageReaction.changeset(message_reaction, %{})
  end

  alias MyHive.Chat.SeenMessage

  def list_chat_seen_messages do
    Repo.all(SeenMessage)
  end

  def get_seen_message!(id), do: Repo.get!(SeenMessage, id)

  def create_seen_message(attrs \\ %{}) do
    %SeenMessage{}
    |> SeenMessage.changeset(attrs)
    |> Repo.insert()
  end

  def update_seen_message(%SeenMessage{} = seen_message, attrs) do
    seen_message
    |> SeenMessage.changeset(attrs)
    |> Repo.update()
  end

  def delete_seen_message(%SeenMessage{} = seen_message) do
    Repo.delete(seen_message)
  end

  def change_seen_message(%SeenMessage{} = seen_message) do
    SeenMessage.changeset(seen_message, %{})
  end
end
