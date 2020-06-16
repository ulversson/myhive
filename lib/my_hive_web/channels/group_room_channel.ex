defmodule MyHiveWeb.GroupRoomChannel do
  use MyHiveWeb, :channel
  alias MyHiveWeb.Endpoint
  alias MyHive.{Chat, Repo, Accounts}
  import MyHiveWeb.Api.V1.Chat.ChatMessageView

  def join("group_room:" <> slug, _params, socket) do
    conv = slug |> Chat.conv_by_name() |> Repo.preload(:conversation_members)
    if Chat.is_member_for_conv?(conv, String.to_integer(socket.assigns.user_id)) do
      Endpoint.subscribe("group_room:"<> slug)
      send(self(), :after_join)
      {:ok, %{}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
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
        unread = Chat.not_seen_messages(new_message.conversation_id, payload["userId"])
        new_message = Map.put(new_message, :avatar, Accounts.User.chat_avatar(new_message.user))
        broadcast socket, "new_message", %{
            message: message_json(new_message),
            unread: Enum.map(unread, &message_json/1),
          }
        {:noreply, socket}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    conv = String.split(socket.topic,":")
      |> Enum.at(1)
      |> Chat.conv_by_name()
    messages = Chat.messages_for_conversation(conv.id)
    push socket, "init:msg", %{
      messages: Enum.map(messages, &message_json/1),
      conversation: conv,
      unread: 0
    }
    {:noreply, socket}
  end

end
