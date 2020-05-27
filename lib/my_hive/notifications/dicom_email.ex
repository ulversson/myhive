defmodule MyHive.Notifications.DicomEmail do
  defstruct [:type, :user, :notification, :medico_legal_case]
end
defimpl MyHive.Notifications.NotificationProtocol,
  for: MyHive.Notifications.DicomEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  alias MyHive.Emails.DicomEmail

  def send(params) do
    DicomEmail.deliver(params.user, params.notification)
  end
end
