defmodule MyHiveWeb.PrivateRoomChannel do
  use MyHiveWeb, :channel
  alias MyHiveWeb.Endpoint
  alias MyHive.Chat
  alias MyHive.Accounts.User
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

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def message_json(msg) do
    %{
      id: msg.id,
      content: msg.content,
      conversation_id: msg.conversation_id,
      user_id: msg.user_id,
      user: %{
        first_name: msg.user.first_name,
        last_name: msg.user.last_name,
        email: msg.user.email
      },
      name: name_for(msg),
      avatar: User.chat_avatar(msg.user)
    }
  end

  defp name_for(msg) do
    msg.user.first_name <> " " <> msg.user.last_name
  end



end
