defmodule MyHive.Notifications.DicomNotificationsResolver do

  import MyHive.Notifications.NotificationsCommon
  alias MyHive.Notifications.{
    WebSocket,
    DicomEmail,
    TextMessage,
    NotificationProtocol
  }

  def call(user, notification, mlc) do
    notifications = []
    if !user.settings.notifications do
      notifications
    else
      notify_map = notifications_settings_map(user, notification, mlc)
      notifications_to_notify(user, notify_map)
      |> Map.values
      |> Enum.each(&NotificationProtocol.send/1)
    end
  end

  def notifications_settings_map(user, notification, mlc) do
    %{
      in_app_notifications:
        %WebSocket{
          topic: "notifications:#{user.id}",
          event: "new_notification",
          payload: notification
        },
      email_notifications:
        %DicomEmail{
          medico_legal_case: mlc,
          notification: notification,
          type: "medico_legal_case",
          user: user
        },
      text_messages_notifications:
        %TextMessage{
          notification: notification,
          type: "radiology"
        }
      }
  end



end
