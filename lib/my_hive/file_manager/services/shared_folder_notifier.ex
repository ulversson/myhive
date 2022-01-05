defmodule MyHive.FileManager.Services.SharedFolderNotifier do

  import MyHive.Notifications.NotificationsCommon
  alias MyHive.{
    Accounts, Notifications
  }
  alias MyHive.Notifications.NotificationProtocol
  alias MyHive.FileManager.Services.Notifications.{
    SharedFolderWebSocket,
    SharedFolderEmail,
    SharedFolderTextMessage
  }

  def call(folder, recipient_id) do
    recipient = Accounts.get_user!(recipient_id)
    notification = generate_notification(folder, recipient)
    notifications = []
    if !recipient.settings.notifications do
      notifications
    else
      notify_map = notifications_settings_map(recipient, notification)
      notifications_to_notify(recipient, notify_map)
      |> Map.values
      |> Enum.each(&NotificationProtocol.send/1)
    end
  end

  def notifications_settings_map(user, notification) do
    %{
      in_app_notifications:
        %SharedFolderWebSocket{
          topic: "notifications:#{user.id}",
          event: "new_notification",
          payload: notification
        },
      email_notifications:
        %SharedFolderEmail{
          notification: notification,
          user: user
        },
      text_messages_notifications:
        %SharedFolderTextMessage{
          notification: notification,
          user: user
        }
      }
  end

  def generate_notification(folder, recipient) do
    owner  = Accounts.get_user!(folder.user_id)
    Notifications.create(recipient, %{
      topic: "[my-hive] #{owner.first_name} #{owner.last_name} shared a folder with you",
      body: "User #{owner.first_name} #{owner.last_name} has shared with you #{folder.name} in the shared items section in my-hive",
      icon: "fas fa-share-alt",
      sender_id: folder.user_id,
      show_on_arrival: true
    })
  end


end
