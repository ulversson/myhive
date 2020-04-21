defmodule MyHiveWeb.UserController do
  use MyHiveWeb, :controller
  alias MyHive.Accounts
  plug :put_root_layout,
    {MyHiveWeb.LayoutView, :root} when action not in [:show]
  plug :put_root_layout,
    {MyHiveWeb.LayoutView, :root} when action not in [:show]

  def index(conn, _params) do
    render conn, "index.html", socket: conn
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn
    |> render(:show, user: user, layout: false)
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn |> json(%{
      message: "User has been deleted successfully.",
      status: "ok"
    })
  end

end
