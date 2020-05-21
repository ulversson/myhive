defmodule MyHiveWeb.Api.V1.Accounts.UserController do
  use MyHiveWeb, :controller
  alias MyHive.Accounts

  def index(conn, _params) do
    user = conn.private.guardian_default_resource
    users = Accounts.all_by_name(user.id)
    conn |> render("index.json", users: users)
  end
end
