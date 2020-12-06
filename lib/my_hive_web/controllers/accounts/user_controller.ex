defmodule MyHiveWeb.UserController do
  use MyHiveWeb, :controller
  alias MyHive.{
    Accounts, CVFields, Repo
  }
  alias MyHive.Accounts.{
    CVFieldUpdater, User
  }

  plug :put_root_layout,
    {MyHiveWeb.LayoutView, :root} when action not in [:show]
  plug :put_root_layout,
    {MyHiveWeb.LayoutView, :root} when action not in [:show]

  def index(conn, _params) do
    render conn, "index.html",
      socket: conn,
      bundle: CVFields.last_bundle
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn
    |> render(:show, user: user, layout: false)
  end

  def delete(conn, %{"id" => id}) do
    id
      |> Accounts.get_user!()
      |> User.cleanup()
    conn |> json(%{
      message: "User has been deleted successfully.",
      status: "ok"
    })
  end

  def cv(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    fields = CVFields.all_user_fields(user)
    conn
      |> render(:cv, user: user, fields: fields)
  end

  def update_fields(conn, %{"user_cv_field" => fields}) do
    CVFieldUpdater.call(fields)
    conn |> send_resp(200, "")
  end

  def signature(conn, _)  do
    user = conn.assigns.current_user.id
     |> Accounts.get_user!()
     |> Repo.preload(:signatures)
    signature = List.first(user.signatures)
    if (is_nil(signature)) do
      conn |> text("")
    else
      conn |> text(signature.content)
    end
  end

end
