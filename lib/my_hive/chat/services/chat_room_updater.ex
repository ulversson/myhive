defmodule MyHive.Chat.Services.ChatRoomUpdater do
  alias MyHive.{
    Chat, Repo
  }
  alias MyHive.Chat.Services.ChatNotifier
  def call(chat_room, user_ids, sender_id) do
    chat_room = Repo.preload(chat_room, :conversation_members)
    Repo.transaction(fn ->
      remove_users_from_chat_room(chat_room, sender_id, user_ids)
      add_users_to_chat_room(chat_room, sender_id, user_ids)
    end)
  end

  def remove_users_from_chat_room(room, sender_id, user_ids) do
    remove_ids = existing_ids(room) -- new_ids(user_ids)
    if length(remove_ids) > 0 do
      Chat.remove_members_from_room(room, remove_ids)
      Enum.each(remove_ids, fn user_id ->
        ChatNotifier.call(:removed, sender_id, room, user_id)
      end)
    end
  end
  def add_users_to_chat_room(room, sender_id, ids) do
    ids_to_add = new_ids(ids)
    add_ids = ids_to_add -- existing_ids(room)
    Enum.each(add_ids, fn user_id ->
      Chat.create_conversation_member(%{
        conversation_id: room.id,
        user_id: user_id
      })
      ChatNotifier.call(:added, sender_id, room, user_id)
    end)
  end

  defp existing_ids(chat_room) do
    Chat.conversation_user_ids(chat_room)
  end

  defp new_ids(ids) do
    ids |> Enum.map(fn x -> String.to_integer(x) end)
  end

end
