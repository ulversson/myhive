defmodule MyHiveWeb.SessionController do
  use MyHiveWeb, :controller

  alias MyHive.Accounts.Auth
  alias MyHive.Repo
  alias MyHive.SmsNotifications.SmsMessage
  plug :put_layout, "login.html"


  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    with {:ok, user} <- Auth.login(auth_params, Repo)  
      do
        case user.has_2fa do
          true ->
            one_time_pass = Auth.generate_one_time_passcode()
            SmsMessage.send_passcode(user, one_time_pass)

          conn
            |> put_session("user_secret", %{"token" => one_time_pass, "user_id" => user.id})
            |> put_flash(:info, "One time passcode has been sent to your mobile")
            |> put_status(302)
            |> redirect(to: "/sessions/new/two_factor_auth")

        false ->
          Auth.login(auth_params, Repo)
          conn 
            |> put_flash(:info, "Login successful! But you should enable two-factor auth")
            |> put_status(302)
            |> redirect(to: Routes.page_path(conn, :index))
        end
      else 
        _ ->
          conn
            |> put_flash(:error, "You entered an invalid password or email!")
            |> put_status(401)
            |> render("new.html")
      end
  end


  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end