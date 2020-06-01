defmodule MyHiveWeb.PrivateRoomChannel do
  use MyHiveWeb, :channel
  alias MyHiveWeb.Endpoint
  alias MyHive.Chat
  alias MyHive.Accounts.User
  import MyHiveWeb.Api.V1.Chat.ChatMessageView

  def join("room:" <> users_string, _params, socket) do
    if users_string
        |> String.split(":")
        |> Enum.member?(socket.assigns.user_id) do
      Endpoint.subscribe("room:"<> users_string)
      send(self(), :after_join)
      {:ok, %{}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    users = String.replace_prefix(socket.topic, "room:", "") |> String.split(":")
    user_id = Enum.at(users, 0)
    opponent_id = Enum.at(users, 1)
    conversation = Chat.private_conv_get_or_create(user_id, opponent_id)
    messages = Chat.messages_for_conversation(conversation.id)
    push socket, "init:msg", %{
      messages: Enum.map(messages, &message_json/1),
      conversation: conversation
      }
    {:noreply, socket}
  end
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

end
