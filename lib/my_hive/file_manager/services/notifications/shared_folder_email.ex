defmodule MyHive.FileManager.Services.Notifications.SharedFolderEmail do
  defstruct [:user, :notification]
end

defimpl MyHive.Notifications.NotificationProtocol,
  for: MyHive.FileManager.Services.Notifications.SharedFolderEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  alias MyHive.Emails.SharedFolderEmail

  def send(params) do
    SharedFolderEmail.deliver(params.user, params.notification)
  end
end
