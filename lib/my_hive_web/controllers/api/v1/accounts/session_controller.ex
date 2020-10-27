defmodule MyHiveWeb.Api.V1.SessionController do
  use MyHiveWeb, :controller

  alias MyHive.Accounts.Auth
  alias MyHive.{Accounts, Repo, Guardian}
  alias MyHive.SmsNotifications.SmsMessage
  plug :put_layout, false

  def create(conn, auth_params) do
    with {:ok, user} <- Auth.login(auth_params, Repo)
      do
        case user.has_2fa do
          true ->
            one_time_pass = Auth.generate_one_time_passcode()
            SmsMessage.send_passcode(user, one_time_pass)
            Accounts.update_user(user, %{mobile_2fa: one_time_pass})
            data = %{"token" => one_time_pass, "user_id" => user.id, "first_name" => user.first_name}
          conn |> json(data)
        false ->
          Auth.login(auth_params, Repo)
          conn |> json("ok")
        end
      else
        _ ->
          conn
            |> put_status(401)
            |> json(%{
              errorCode: 401,
              description: "You entered an invalid password or email!"
            })
      end
  end

  def two_factor_auth(conn, %{"token" => one_time_pass, "user_id" => user_id}) do
    user = Accounts.get_user!(user_id)
    case one_time_pass == user.mobile_2fa do
      true ->
        if user.verified do
          {:ok, jwt, _claims} = Guardian.encode_and_sign(user)
          GuardianTrackable.track!(MyHive.Repo, user, conn.remote_ip)
          conn
            |> json(%{
              jwt: jwt,
              user_id: user.id,
              first_name: user.first_name,
              last_name: user.last_name,
              avatar: user.avatar_32
            })
        else
          conn
           |> put_status(422)
           |> json(%{error: "You have to confirm your email address before continuing"})
        end
      false ->
        conn
          |> json(%{error: "The authentication code you entered was invalid!"})
          |> put_status(422)
    end
  end

end
