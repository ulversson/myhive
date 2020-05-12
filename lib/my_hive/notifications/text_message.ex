defmodule MyHive.Notifications.TextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.TextMessage do

      alias MyHive.SmsNotifications.SmsMessage
      alias MyHive.{Accounts, Repo}
      import MyHive.CaseManagement.MedicoLegalCaseNotificationData

    def send(%{
       notification: notification,
       type: "medico_legal_case",
       medico_legal_case: medico_legal_case}) do

       medico_legal_case = Repo.preload(medico_legal_case, [:patient, :user])
       user = Accounts.get_user!(notification.recipient_id)
       SmsMessage.send_message(user.phone_number, body_message(medico_legal_case))
    end

end

end
