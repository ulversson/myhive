defmodule MyHive.CaseManager.MedicoLegalCaseNotificationRemindResolver do

  import MyHive.Notifications.NotificationsCommon
  alias MyHive.Notifications.{
    WebSocket,
    NotificationProtocol,
    MedicoLegalCaseReminderEmail,
    MedicoLegalCaseReminderTextMessage
  }

  def call(user, notification, mlc) do
    cond do
      !user.settings.notifications -> []
      mlc.notifications_disabled -> []
      true ->
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
        %MedicoLegalCaseReminderEmail{
          user: user,
          notification: notification,
          medico_legal_case: mlc
        },
      text_messages_notifications:
        %MedicoLegalCaseReminderTextMessage{
          notification: notification,
          user: user
        }
      }
  end

end
