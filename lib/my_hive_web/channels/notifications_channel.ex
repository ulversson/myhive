defmodule MyHiveWeb.NotificationsChannel do
  use Phoenix.Channel
  alias MyHiveWeb.Endpoint

  def join("notifications:" <> user_id, _info, socket) do
    if user_id != "" do
      Endpoint.subscribe("notifications:" <> user_id)

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

 def handle_in("access_granted", is_granted, socket) do
  broadcast! socket, "access_granted", is_granted
  {:noreply, socket}
  end
end
