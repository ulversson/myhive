defmodule MyHiveWeb.Api.V1.NotificationController do
  use MyHiveWeb, :controller
  alias MyHive.Notifications
  action_fallback MyHiveWeb.FallbackController

  def unread(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    data = Notifications.unread_for_user(current_user.id)
    conn |> json(%{
      count: length(data),
      data: data
    })
  end

  def delete(conn, %{"ids" => ids}) do
    ids_ary = String.split(ids, ",")
    Notifications.view_all(ids_ary)
    conn |> json(%{"success" => "true"})
  end

end
