defmodule MyHiveWeb.UserController do
  use MyHiveWeb, :controller

  alias MyHive.Accounts
  alias MyHive.Accounts.User
  alias MyHive.Accounts.Token
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
  def verify_email(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_new_account_token(token),
         {:ok, %User{verified: false} = user} <- Accounts.get_user!(user_id) do
      Accounts.mark_as_verified(user)
      render(conn, "verified.html")
    else
      _ -> render(conn, "invalid_token.html")
    end
  end

  def verify_email(conn, _) do
    conn
    |> put_flash(:error, "The verification link is invalid.")
    |> redirect(to: "/")
  end

end
