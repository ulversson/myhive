defmodule MyHiveWeb.Api.V1.Accounts.UserController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Chat, Accounts
  }
  alias MyHive.Chat.Conversation

  def index(conn, %{"conversation" => conv}) do
    user = conn.private.guardian_default_resource
    users = Chat.conversation_members(user.id, conv)
    conversation = Chat.conv_by_name(conv)
    users = get_last_message(users, user)
      |> get_unread_count(user)
    conn |> render(
      "index.json",
      users: users,
      conv: conversation,
      user: user
    )
  end

  def update_mobile(conn, %{"id" => user_id, "mobile" => phone_number}) do
    user_id
      |> Accounts.get_user!()
      |> Accounts.update_user(%{phone_number: phone_number})
    conn |> json(%{success: true, phone_number: phone_number})
  end

  def update_mobile(conn, _) do
    conn |> json(%{success: false, phone_number: nil})
  end

  defp get_last_message(users, user) do
    Enum.map(users, fn  opponent ->
      Map.put(opponent, :last_message, Chat.last_message_for_conv(user.id, opponent.id))
    end)
  end

  defp get_unread_count(users, user) do
    Enum.map(users, fn  opponent ->
      conv = Chat.private_conv_between(user.id, opponent.id) |> MyHive.Repo.one()
      unread = Conversation.new_message_count(conv, opponent.id)
      opponent
        |> Map.put(:unread_messages, unread)
        |> Map.put(:conv_id, conv.id)
    end)
  end
end
