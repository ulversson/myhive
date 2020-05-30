defmodule MyHiveWeb.Api.V1.Accounts.UserView do
  use MyHiveWeb, :view
  alias MyHive.Accounts.User
  def render("index.json", %{users: users, conv: conversation}) do
    %{
       data: Enum.map(users, &user_json/1),
       conversation: conv_json(conversation)
     }
  end

  def conv_json(conversation) do
    %{
      id: conversation.id,
      title: conversation.title,
      slug: conversation.slug
    }
  end
  def user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      avatar: User.chat_avatar(user),
      phone_number: user.phone_number,
      roles: user.roles
    }
  end
end
