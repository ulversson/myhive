defmodule MyHiveWeb.Plugs.ShareableDirectoryNotifier do
  use Ecto.Schema
  alias MyHive.Notifications.{
    NotificationProtocol,
    WebSocket
  }
  alias MyHive.{
    Shareable, Notifications
  }

  def call(directory) do
    directory = Shareable.preload_all(directory)
    make_and_send_notification(directory)
  end

  defp make_and_send_notification(directory) do
    notification = Notifications.create(directory.sharer, %{
      topic: "[myHive] User has confirmed his identity",
      body: "User #{name(directory)} has authorized his identity and has been granted access to the shared files.",
      icon: "fas fa-user-shield",
      sender_id: directory.sharer.id,
      show_on_arrival: true
    })
    web_socket = %WebSocket{
      topic: "notifications:#{directory.sharer.id}",
      event: "new_notification",
      payload: notification
    }
    NotificationProtocol.send(web_socket)
  end

  defp name(dir) do
    "<strong>" <> dir.first_name <> " " <> dir.last_name <> "</strong>"
  end
end
