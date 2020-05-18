defmodule MyHiveWeb.Plugs.ShareableDirectoryNotifier do
  use Ecto.Schema
  alias MyHive.Notifications.{
    NotificationProtocol,
    WebSocket
  }
  alias MyHive.{
    Shareable, Notifications
  }

  def call(directory, email) do
    directory = Shareable.preload_all(directory)
    make_and_send_notification(email, directory)
  end

  defp make_and_send_notification(_email, directory) do
    notification = Notifications.create(directory.sharer, %{
      topic: "[myHive] User has confirmed his identity",
      body: "User #{name(directory)} has confirmed his identity and requested access to view the shared files.
        Please click <strong><a class='notification-link' href='javascript:void' data-url='/api/v1/shareable/grant/#{directory.id}' style='color: white; text-decoration: underline; font-size: 14px'>here</a></strong> to grant access",
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
