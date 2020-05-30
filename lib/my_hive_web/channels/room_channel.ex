defmodule MyHiveWeb.RoomChannel do
  use MyHiveWeb, :channel
  alias MyHiveWeb.Presence
  alias MyHiveWeb.Endpoint
  alias MyHive.{
    Chat, Repo, Accounts
  }

  def join("room:lobby", _params, socket) do
    send(self(), :after_join)
    Endpoint.subscribe("room:lobby" <> socket.assigns.user_id)

    {:ok, socket}
  end
  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user_id, %{
      online_at: :os.system_time(:second),
      typing: false,
      user_id: socket.assigns.user_id
    })
    users = Presence.list(socket)
    push socket, "presence_state", users
    {:noreply, socket}
  end
  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_message", payload, socket) do
    case Chat.create_message(%{
        conversation_id: payload["conversationId"],
        user_id: payload["userId"],
        content: payload["text"]
      }) do
      {:ok, new_message} ->
        new_message = Repo.preload(new_message, [
          :conversation, :user
        ])
        new_message = Map.put(new_message, :avatar, Accounts.User.chat_avatar(new_message.user))
        broadcast socket, "new_message", new_message
        {:noreply, socket}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_out("presence_diff", payload, socket) do
    # Only gets triggered at Presence.track, but not when the connection is closed.
    IO.puts("presence_diff triggered, payload is #{inspect(payload)}")

    leaves = payload.leaves

    for {_experiment_id, meta} <- leaves do
      IO.puts("Leave information: #{meta}")

      # Do stuffs
    end

    {:noreply, socket}
  end

end
