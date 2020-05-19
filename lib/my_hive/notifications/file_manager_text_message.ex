defmodule MyHive.Notifications.FileManagerTextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.FileManagerTextMessage do

      alias MyHive.SmsNotifications.SmsMessage
      alias MyHive.Accounts

    def send(%{notification: notification, type: "file_manager"}) do
      user = Accounts.get_user!(notification.recipient_id)
      SmsMessage.send_message(user.phone_number, notification.body)
    end

  end

end