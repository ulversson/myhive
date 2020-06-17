defmodule MyHive.Chat.Services.ChatNotifier do
  alias MyHive.{
    Accounts, Notifications
  }
  alias MyHiveWeb.Endpoint

  def call(action, sender_id, room, user_id) do
    user = user_id |> Accounts.get_user!()
    if action === :added do
      Endpoint.broadcast!(
        "notification:#{user.id}",
        "new_notification",
        add_notification(sender_id, room, user)
      ) else
      Endpoint.broadcast!(
        "notification:#{user.id}",
        "new_notification",
        del_notitication(sender_id, room, user)
      )
    end
  end

  defp add_notification(sender_id, room, user) do
    Notifications.create(user, %{
      sender_id: sender_id,
      icon: "fas fa-comments",
      topic: "[myHive] You have been added to the chat room",
      body: "You have been added to the chat room #{room.title}"
    })
  end

  defp del_notitication(sender_id, room, user) do
    Notifications.create(user, %{
      sender_id: sender_id,
      icon: "fas fa-comments",
      topic: "[myHive] You have been removed from chat room",
      body: "You have been removed from the chat room: #{room.title}"
    })
  end
end
