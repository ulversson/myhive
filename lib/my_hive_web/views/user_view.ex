defmodule MyHiveWeb.UserView do
  use MyHiveWeb, :view
  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("user.json", %{user: user}) do
    %{
      first_name: user.first_name,
      last_name: user.last_name,
      id: user.id
    }
  end
end
