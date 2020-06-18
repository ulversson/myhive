defmodule MyHiveWeb.VideoChannel do
  use MyHiveWeb, :channel
  alias MyHive.Chat.Services.ChatMissedCallNotifier
  def join("video:peer2peer", _message, socket) do
    {:ok, socket}
  end

  def handle_in("peer-message", %{"body" => body}, socket) do
    broadcast_from!(socket, "peer-message", %{body: body, user_id: socket.assigns.user_id})
    {:noreply, socket}
  end

  def handle_in("incoming-call", %{"user" => user}, socket) do
    broadcast_from!(socket, "incoming-call", %{user: user})
    {:noreply, socket}
  end

  def handle_in("missed-call", %{"recipient_id" => rec_id, "sender_id" => sender_id}, socket) do
    ChatMissedCallNotifier.call(rec_id, sender_id)
    {:noreply, socket}
  end

  def handle_in("hangup", %{"name" => modal}, socket) do
    broadcast_from!(socket, "hangup", %{"name" => modal})
    {:noreply, socket}
  end
end
