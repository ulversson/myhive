defmodule MyHive.Notifications.FileManagerTextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case, :device_id]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.FileManagerTextMessage do

    alias MyHive.Accounts
    alias MyHive.Accounts.User

    def send(%{notification: notification, type: "file_manager"}) do
      user = Accounts.get_user!(notification.recipient_id)
      User.notify_devices(user, notification.body)
    end

  end

end
