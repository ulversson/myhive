defmodule MyHiveWeb.UserView do
  use MyHiveWeb, :view
  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
