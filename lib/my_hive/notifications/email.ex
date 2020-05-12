defmodule MyHive.Notifications.Email do
  defstruct [:type, :user, :notification, :medico_legal_case]
end
defimpl MyHive.Notifications.NotificationProtocol,
  for: MyHive.Notifications.Email do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  alias MyHive.Emails.MedicoLegalCaseEmail

  def send(params) do
    MedicoLegalCaseEmail.deliver(params.user, params.notification, params.medico_legal_case)
  end
end
