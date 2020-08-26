defmodule MyHive.Notifications.MedicoLegalCaseReminderTextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.MedicoLegalCaseReminderTextMessage do

    alias MyHive.SmsNotifications.SmsMessage

    def send(%{notification: notification, user: user}) do
      SmsMessage.send_message(user.phone_number, notification.body)
    end

  end

end
