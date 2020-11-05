defmodule MyHive.Notifications.MedicoLegalCaseReminderTextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.MedicoLegalCaseReminderTextMessage do

    alias MyHive.Accounts.User

    def send(%{notification: notification, user: user}) do
      User.notify_devices(user, notification.body)
    end

  end

end
