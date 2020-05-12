defmodule MyHive.Notifications.NotificationsResolver do

  alias MyHive.Notifications.{
    WebSocket,
    Email,
    TextMessage,
    NotificationProtocol
  }

  def call(user, notification, mlc) do
    notifications = []
    if !user.settings.notifications do
      notifications
    else
      enabled_notifications = enabled_notifications_for_user(user)
      notify_map = notifications_settings_map(user, notification, mlc)
      :maps.filter(fn k, _v ->
        enabled_notifications[k] == true end, notify_map)
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
        %Email{
          medico_legal_case: mlc,
          notification: notification,
          type: "medico_legal_case",
          user: user
        },
      text_messages_notifications:
        %TextMessage{
          notification: notification,
          type: "medico_legal_case",
          medico_legal_case: mlc
        }
      }
  end

  def enabled_notifications_for_user(user) do
    notification_settings = Map.take(user.settings,
      [:in_app_notifications, :email_notifications, :text_messages_notifications])
    :maps.filter(fn _, v -> v == true end, notification_settings)
  end

end
