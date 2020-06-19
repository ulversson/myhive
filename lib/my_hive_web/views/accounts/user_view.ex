defmodule MyHiveWeb.Api.V1.Accounts.UserView do
  use MyHiveWeb, :view
  alias MyHive.Accounts.User
  def render("index.json", %{users: users, conv: conversation, user: user}) do
    %{
       data: Enum.map(users, fn user -> user_json(user) end),
       conversation: conv_json(conversation),
       roles: user.roles
     }
  end

  def conv_json(conversation) do
    %{
      id: conversation.id,
      title: conversation.title,
      slug: conversation.slug,
      private: conversation.private
    }
  end

  def user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      conv_id: user.conv_id,
      last_message: message_json(user.last_message),
      unread: Enum.map(user.unread_messages,
        fn msg -> message_json(msg) end
      ),
      avatar128: user.avatar_128,
      avatar: User.chat_avatar(user),
      phone_number: user.phone_number,
      roles: user.roles
    }
  end

  defp message_json(msg) when is_map(msg) do
    %{
      id: msg.id,
      content: msg.content,
      inserted_at: msg.inserted_at
    }
  end

  defp message_json(msg) when is_nil(msg) do
    %{}
  end
end
