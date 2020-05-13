defmodule MyHive.Notifications.FileManagerEmail do
  defstruct [:type, :user, :notification, :medico_legal_case]
end
defimpl MyHive.Notifications.NotificationProtocol,
  for: MyHive.Notifications.FileManagerEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  alias MyHive.Emails.FileManagerEmail

  def send(params) do
    FileManagerEmail.deliver(params.user, params.notification)
  end
end
