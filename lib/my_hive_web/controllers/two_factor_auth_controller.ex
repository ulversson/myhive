defmodule MyHiveWeb.TwoFactorAuthController do

use MyHiveWeb, :controller
import Plug.Conn
alias MyHive.Accounts
alias MyHive.Guardian
plug :put_layout, "login.html"

def new(conn, _) do
  with %{} <- get_session(conn, "user_secret") do
    conn
    |> render("two_factor_auth.html", action: "/sessions/new/two_factor_auth")
  else
  _ ->
    conn
    |> put_flash(:error, "Page not found")
    |> put_status(404)
    |> redirect(to: Routes.session_path(conn, :new))
  end
end

def create(conn, %{"one_time_pass" => one_time_pass}) do
  %{"token" => token, "user_id" => user_id} = get_session(conn, "user_secret")
  user = Accounts.get_user!(user_id)

  case one_time_pass == token do
    true ->
      {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
      GuardianTrackable.track!(MyHive.Repo, user, conn.remote_ip)
      conn
        |> delete_session("user_secret")
        |> put_session(:current_user_id, user.id)
        |> put_session(:jwt, jwt)
        |> put_flash(:info, "Login successful!")
        |> put_status(302)
        |> redirect(to: Routes.page_path(conn, :index))
    false ->
      conn
        |> put_flash(:error, "The authentication code you entered was invalid!")
        |> put_status(401)
        |> render("two_factor_auth.html", action: Routes.two_factor_auth_path(conn, :create))
  end
end

end
