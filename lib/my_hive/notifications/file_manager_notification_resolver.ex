defmodule MyHive.Notifications.FileManagerNotificationsResolver do

  import MyHive.Notifications.NotificationsCommon
  alias MyHive.Notifications.{
    WebSocket,
    FileManagerTextMessage,
    FileManagerEmail,
    NotificationProtocol
  }

  def call(user, notification, mlc, device_id) do
    cond do
      !user.settings.notifications -> []
      mlc.notifications_disabled -> []
      true ->
        notify_map = notifications_settings_map(user, notification, device_id)
        notifications_to_notify(user, notify_map)
        |> Map.values
        |> Enum.each(&NotificationProtocol.send/1)
    end
  end

  def notifications_settings_map(user, notification, device_id) do
    %{
      in_app_notifications:
        %WebSocket{
          topic: "notifications:#{user.id}",
          event: "new_notification",
          payload: notification
        },
      email_notifications:
        %FileManagerEmail{
          user: user,
          notification: notification
        },
      text_messages_notifications:
        %FileManagerTextMessage{
          notification: notification,
          type: "file_manager",
          device_id: device_id
        }
      }
  end

end
