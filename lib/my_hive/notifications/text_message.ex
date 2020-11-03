defmodule MyHive.Notifications.TextMessage do
  defstruct [:type, :notification, :user, :medico_legal_case]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.Notifications.TextMessage do

      alias MyHive.Notifications.MobileNotifier
      alias MyHive.{Accounts, Repo}
      import MyHive.CaseManagement.MedicoLegalCaseNotificationData

    def send(%{
       notification: notification,
       type: "medico_legal_case",
       medico_legal_case: medico_legal_case}) do

       medico_legal_case = Repo.preload(medico_legal_case, [:patient, :user])
       user = Accounts.get_user!(notification.recipient_id)
       MobileNotifier.call(user, body_message(medico_legal_case))
    end

    def send(%{
      notification: notification,
      type: "radiology"}) do

      user = Accounts.get_user!(notification.recipient_id)
      body = String.replace(notification.body, "<strong>","")
        |> String.replace("</strong>","")
      MobileNotifier.call(user, body)
   end


end

end
