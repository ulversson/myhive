defmodule MyHive.FileManager.Services.Notifications.SharedFolderTextMessage do
  defstruct [:notification, :user]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.FileManager.Services.Notifications.SharedFolderTextMessage do

    alias MyHive.SmsNotifications.SmsMessage
    def send(%{
          notification: notification,
          user: user
        }) do

      SmsMessage.send_message(user.phone_number, notification.body)
    end
  end
end
