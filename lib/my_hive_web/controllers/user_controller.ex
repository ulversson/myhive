defmodule MyHiveWeb.UserController do
  use MyHiveWeb, :controller

  alias MyHive.Accounts
  alias MyHive.Accounts.User
  plug :put_layout, "login.html"

  def index(conn, _params) do
    render conn, "index.html",
    layout: {MyHiveWeb.LayoutView, "app.html"}
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: Routes.page_path(conn, :show))
    {:error, %Ecto.Changeset{} = changeset} ->
      render(conn, "new.html", changeset: changeset)
    end
  end

end