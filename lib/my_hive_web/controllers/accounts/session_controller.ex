defmodule MyHiveWeb.SessionController do
  use MyHiveWeb, :controller

  alias MyHive.Accounts.Auth
  alias MyHive.{
    Repo, Accounts, Guardian
  }
  alias MyHive.Accounts.User
  alias MyHive.SmsNotifications.SmsMessage
  alias MyHiveWeb.ApiFallbackController
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
            message = SmsMessage.passcode_text(one_time_pass)
            User.notify_devices(user, message)
          conn
            |> put_session("user_secret", %{"token" => one_time_pass, "user_id" => user.id})
            |> put_flash(:info, "One time passcode has been sent to your mobile")
            |> put_status(302)
            |> redirect(to: "/sessions/new/two_factor_auth")
          false ->
            {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
            {:ok, refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
            GuardianTrackable.track!(MyHive.Repo, user, conn.remote_ip)
            conn
              |> delete_session("user_secret")
              |> put_session(:current_user_id, user.id)
              |> put_flash(:info, "Login successful. You should enable 2 factor authentication")
              |> put_session(:jwt, jwt)
              |> put_session(:ref, refresh)
              |> put_status(302)
              |> redirect_page(user)
        end
      else
        _ ->
          conn
            |> put_flash(:error, "You entered an invalid password or email!")
            |> put_status(401)
            |> render("new.html")
      end
  end

  def mark_for_sign_out(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    if user do
      Accounts.mark_for_sign_out(user)
      conn |> json(%{
        message: "This user will be signed out with the next action",
        status: "ok",
        id: user.id
      })
      else
       conn
       |> put_status(422)
       |> json(%{
          message: "Unable to mark this user for sign out",
          status: "failed"
        })
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> delete_session(:current_user)
    |> delete_session(:jwt)
    |> delete_session(:ref)
    |> put_flash(:info,  "Signed out successfully")
    #|> Guardian.Plug.sign_out()
    |> redirect(to: Routes.session_path(conn, :new))
  end

  def delete(conn, %{"reason" => reason}) do
    conn
    |> delete_session(:current_user_id)
    |> delete_session(:current_user)
    |> delete_session(:jwt)
    |> delete_session(:ref)
    |> put_flash(:info,  message_from_reason(reason))
    #|> Guardian.Plug.sign_out()
    |> redirect(to: Routes.session_path(conn, :new))
  end

  def refresh(conn, %{"jwt_refresh" => jwt_refresh}) do
    case MyHive.Guardian.exchange(jwt_refresh, "refresh", "access") do
      {:ok, _old_stuff, {jwt,  _new_claims}} ->
        user = Accounts.get_user!(get_session(conn, :current_user_id))
        {:ok, refresh, _claims} = Guardian.encode_and_sign(user, %{}, token_type: "refresh")
        conn
        |> put_session(:jwt, jwt)
        |> put_session(:jwt, refresh)
        |> json(%{jwt: jwt, refresh: refresh})
      {:error, _reason} ->
        conn
        |> ApiFallbackController.call({:error, :unauthorized})
    end
  end

  defp message_from_reason(reason)  when is_nil(reason) do
    "Signed out successfully."
  end

  defp message_from_reason(reason)  when is_binary(reason) do
    case reason do
      "expired" -> "Your session has expired"
    end
  end


  defp redirect_page(conn, user) do
    if user.sign_in_count == 0 do
    conn
      |> put_flash(:info, "You are signing in for the first time. Please change your password")
      |> redirect(to: Routes.password_path(conn, :new))
    else
      conn
      |> put_flash(:info, "Login successful!")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
