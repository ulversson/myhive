defmodule MyHive.Oauth2.MicrosoftAuthController do
  use MyHiveWeb, :controller
  plug Ueberauth

  alias MyHive.Oauth2
  alias Ueberauth.Strategy.Helpers
  alias MyHive.Oauth2.Microsoft.UserFromAuth

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, params) do
    user_id = conn.private.plug_session["current_user_id"]
    Oauth2.withdraw(user_id, String.capitalize(params["provider"]))
    conn
      |> put_flash(:info, "Authorization revoked")
      |> json(%{success: true})
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/profile")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    user_id = conn.private.plug_session["current_user_id"]
    case UserFromAuth.find_or_create(auth, user_id, "Microsoft") do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/profile")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end



end
