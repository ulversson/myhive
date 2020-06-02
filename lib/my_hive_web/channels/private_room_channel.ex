defmodule MyHiveWeb.PrivateRoomChannel do
  use MyHiveWeb, :channel
  alias MyHiveWeb.Endpoint
  alias MyHive.{Chat, Repo, Accounts}
  alias MyHive.Chat.Conversation
  import MyHiveWeb.Api.V1.Chat.ChatMessageView

  def join("room:" <> users_string, _params, socket) do
    if users_string
        |> String.split(":")
        |> Enum.member?(socket.assigns.user_id) do
      Endpoint.subscribe("room:"<> users_string)
      Endpoint.subscribe("list:update:#{}")
      send(self(), :after_join)
      {:ok, %{}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_message", payload, socket) do
    require IEx; IEx.pry
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
    users = users_ary(socket.topic)
    user_id = Enum.at(users, 0)
    opponent_id = Enum.at(users, 1)
    conversation = Chat.private_conv_get_or_create(user_id, opponent_id)
    messages = Chat.messages_for_conversation(conversation.id)
    new_messages = Conversation.new_message_count(conversation, opponent_id)
    push socket, "init:msg", %{
      messages: Enum.map(messages, &message_json/1),
      conversation: conversation,
      unread: Enum.map(new_messages, &message_json/1)
    }
    Chat.view_messages(new_messages, opponent_id)
    {:noreply, socket}
  end

  defp users_ary(users_string) do
    String.replace_prefix(users_string, "room:", "")
     |> String.split(":")
  end

  def handle_out("list:update", _payload, socket) do
    {:noreply, socket}
  end


end
