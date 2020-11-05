defmodule MyHive.Notifications.TextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case, :device_id]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.TextMessage do

      alias MyHive.{Accounts, Repo}
      alias MyHive.Accounts.User
      import MyHive.CaseManagement.MedicoLegalCaseNotificationData

    def send(%{
       notification: notification,
       type: "medico_legal_case",
       medico_legal_case: medico_legal_case}) do
       medico_legal_case = Repo.preload(medico_legal_case, [:patient, :user])
       user = Accounts.get_user!(notification.recipient_id)
       User.notify_devices(user, body_message(medico_legal_case))
    end

    def send(%{
      notification: notification,
      type: "radiology"}) do

      user = Accounts.get_user!(notification.recipient_id)
      body = String.replace(notification.body, "<strong>","")
        |> String.replace("</strong>","")
      User.notify_devices(user, body)
   end


end

end
