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
    SeenMessage,
    MessageReaction,
    UnsavedAttachment
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

  def conv_by_id(id) do
    Repo.get_by(Conversation, id: id)
  end

  def unsaved_attachment(id) do
    Repo.get_by(UnsavedAttachment, id: id)
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

  def conv_for_member_id(member_id) do
    query = from co in Conversation,
      where: co.private == false,
      join: cm in assoc(co, :conversation_members),
      where: cm.user_id == ^member_id,
      where: co.slug != "myhive-lobby",
      preload: [:conversation_members],
      order_by: co.title,
      group_by: co.id
    Repo.all(query)
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

  def last_message_for_conv(user_id, opponent_id) do
    conv = private_conv_get_or_create(user_id, opponent_id)
    last_message_for(conv.id, opponent_id)
  end

  def last_message_for(conv_id, user_id) do
    query = from m in Message,
      where: m.conversation_id == ^conv_id and m.user_id == ^user_id,
      limit: 1,
      order_by: [{:desc, :inserted_at}]
    Repo.one(query)
  end

  def messages_for_conv_query(conv_id) do
    from m in Message,
      where: m.conversation_id == ^conv_id,
      limit: 50,
      preload: [:user],
      order_by: [:id]
  end

  def messages_by_user_id(conv_id, user_id) do
    query = messages_for_conv_query(conv_id)
    query = from m in query,
      where: m.user_id == ^user_id
    Repo.all(query)
  end

  def not_seen_messages(conv_id, user_id) do
    query = from m in Message,
      left_join: sm in SeenMessage,
      on: m.id == sm.message_id,
      where: m.conversation_id == ^conv_id,
      preload: [:user],
      where: m.user_id == ^user_id,
      where: is_nil sm.message_id
    Repo.all(query)
  end

  def seen_messages_for(conv_id, user_id) do
    query  = from sm in SeenMessage,
      join: m in assoc(sm, :message),
      join: u in assoc(sm, :user),
      where: m.conversation_id == ^conv_id,
      preload: [:message],
      where: sm.user_id == ^user_id
    seen_msgs = Repo.all(query)
    Enum.map(seen_msgs, fn smsg -> smsg.message end)
  end

  def messages_for_conversation(conv_id) do
    query = messages_for_conv_query(conv_id)
    Repo.all(query)
  end

  def view_messages(messages, user_id) do
    Enum.each(messages, fn msg ->
      create_seen_message(%{
        message_id: msg.id,
        user_id: user_id
      })
    end)
  end

  def create_conversation_with_members(conv_attrs, members_ids) do
    Repo.transaction(fn ->
      {:ok, conv} = create_conversation(conv_attrs)
      Enum.each(members_ids, fn user_id ->
        create_conversation_member(%{conversation_id: conv.id, user_id: user_id, owner: false})
      end)
    end)
  end

  def conversation_user_ids(conv) do
    Enum.map(conv.conversation_members, fn member ->
      member.user_id
    end)
  end

  def unsaved_attachment(conv_id, user_id) do
    query  = from ua in UnsavedAttachment,
      where: ua.conversation_id == ^conv_id,
      where: ua.user_id == ^user_id,
      order_by: [desc: ua.id],
      limit: 1
    Repo.one(query)
  end

  def remove_members_from_room(room, members_ids) do
    query = from m in ConversationMember,
      where: m.conversation_id == ^room.id,
      where: m.user_id in ^members_ids
    Repo.delete_all(query)
  end

  def remove_all(slug) do
    conv = slug |> conv_by_name() |> Repo.preload([:conversation_members, :messages])
    Repo.transaction(fn ->
      Enum.map(conv.conversation_members, fn member ->
        delete_conversation_member(member)
      end)
      Enum.map(conv.messages, fn msg ->
        delete_message(msg)
      end)
      delete_conversation(conv)
    end)
  end

  def is_member_for_conv?(conv, member_id) do
    ids = conversation_user_ids(conv)
    Enum.member?(ids, member_id)
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

  def create_unsaved_attachment(attrs \\ %{}) do
    %UnsavedAttachment{}
    |> UnsavedAttachment.changeset(attrs)
    |> Repo.insert()
  end

  def delete_unsaved_attachment(%UnsavedAttachment{} = attachment) do
    Repo.delete(attachment)
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

  def delete_conversation_members_for(user_id) do
    query = from cm in ConversationMember,
      where: cm.user_id == ^user_id
    Repo.delete_all(query)
  end
end
