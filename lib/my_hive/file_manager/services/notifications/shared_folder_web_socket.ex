defmodule MyHive.FileManager.Services.Notifications.SharedFolderWebSocket do
  defstruct [:topic, :event, :payload]

  defimpl MyHive.Notifications.NotificationProtocol,
    for: MyHive.FileManager.Services.Notifications.SharedFolderWebSocket do
    alias MyHiveWeb.Endpoint

    def send(n) do
      Endpoint.broadcast!(n.topic, n.event, n.payload)
    end
  end

end
