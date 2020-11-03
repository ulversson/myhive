defmodule MyHive.Notifications.MedicoLegalCaseReminderTextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.MedicoLegalCaseReminderTextMessage do

    alias MyHive.Notifications.MobileNotifier

    def send(%{notification: notification, user: user}) do
      MobileNotifier.call(user, notification.body)
    end

  end

end
