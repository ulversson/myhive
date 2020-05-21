defmodule MyHiveWeb.Api.V1.Accounts.UserView do
  use MyHiveWeb, :view
  def render("index.json", %{users: users}) do
    %{
       data: Enum.map(users, &user_json/1)
     }
  end
  def user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      avatar: user.avatar_32,
      phone_number: user.phone_number,
      roles: user.roles
    }
  end
end
