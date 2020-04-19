defmodule MyHiveWeb.PasswordController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
  alias MyHive.Accounts
  def new(conn, _params) do
    changeset = Accounts.change_user(conn.assigns.current_user)
    render(conn, :new, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    changeset = conn.assigns.current_user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :update)
    if changeset.valid? do
      Accounts.update_password(changeset, user_params["password"])
      conn
      |> put_flash(:info, "Password has been successfully changed")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Sorry, we were unable to save this new password")
      |> render("new.html", changeset: changeset)
    end
  end

end
