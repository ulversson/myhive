defmodule MyHiveWeb.Api.V1.Chat.ChatMessageView do
  use MyHiveWeb, :view
  alias MyHive.Accounts.User
  alias MyHive.Repo

  def render("messages.json", %{messages: messages}) do
   messages = Repo.preload(messages, :user)
  %{
     data: Enum.map(messages, &message_json/1),
   }
  end

  def message_json(msg) do
    %{
      id: msg.id,
      content: msg.content,
      conversation_id: msg.conversation_id,
      user_id: msg.user_id,
      inserted_at: msg.inserted_at,
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
