defmodule MyHiveWeb.Notifications.NotificationController do
  use MyHiveWeb, :controller
  alias MyHive.Notifications
  plug :put_root_layout, false
  plug :put_layout, false

  def show(conn, %{"id" => id}) do
    notification = Notifications.get_notification!(id)
    Notifications.view(notification)
    conn |> render("show.html", notification: notification)
  end

end
