defmodule MyHive.Notifications.MedicoLegalCaseReminderEmail do
  defstruct [:user, :notification, :medico_legal_case]
end
defimpl MyHive.Notifications.NotificationProtocol,
  for: MyHive.Notifications.MedicoLegalCaseReminderEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  alias MyHive.Emails.MedicoLegalCaseReminderEmail

  def send(params) do
    MedicoLegalCaseReminderEmail.deliver(params.user, params.notification, params.medico_legal_case)
  end
end
