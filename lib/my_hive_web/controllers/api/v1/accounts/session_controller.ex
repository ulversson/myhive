defmodule MyHiveWeb.Api.V1.SessionController do
  use MyHiveWeb, :controller

  alias MyHive.Accounts.Auth
  alias MyHive.Repo
  alias MyHive.SmsNotifications.SmsMessage
  plug :put_layout, false

  def create(conn, auth_params) do
    with {:ok, user} <- Auth.login(auth_params, Repo)
      do
        case user.has_2fa do
          true ->
            one_time_pass = Auth.generate_one_time_passcode()
            SmsMessage.send_passcode(user, one_time_pass)
            data = %{"token" => one_time_pass, "user_id" => user.id}
          conn
            |> json(data)

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

end
