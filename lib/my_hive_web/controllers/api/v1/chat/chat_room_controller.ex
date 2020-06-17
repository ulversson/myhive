defmodule MyHiveWeb.Api.V1.Chat.ChatRoomController do
  use MyHiveWeb, :controller
  alias MyHive.Chat
  alias MyHive.Chat.Services.ChatRoomUpdater

  def index(conn, %{"member_id" => member_id}) do
    conversations = Chat.conv_for_member_id(member_id)
    conn |> render("conversations.json",
      convs: conversations)
  end

  def create(conn, %{"chat_room" => chat_room, "user_ids" => ids}) do
    Chat.create_conversation_with_members(chat_room, ids)
    conn |> json(%{"success" => true})
  end

  def update(conn, %{"id" => id, "user_ids" => user_ids}) do
    case Chat.conv_by_id(id) do
      nil ->
        conn |> json(%{"success" => false})
      conv ->
        user = conn.private.guardian_default_resource
        ChatRoomUpdater.call(conv, user_ids, user.id)
        conn |> json(%{"success" => true})
    end
  end

  def destroy(conn, %{"id" => slug}) do
    Chat.remove_all(slug)
    conn |> json(%{"success" => true})
  end
end
