defmodule MyHiveWeb.NotificationsChannel do
  use Phoenix.Channel

  def join("notifications:" <> user_id, _info, socket) do
    if user_id != "" do
      send(self(), :after_join)
      {:ok, %{}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

 def handle_in("new_notification", notification, socket) do
   broadcast! socket, "new_notification", notification
  {:noreply, socket}
 end
end
