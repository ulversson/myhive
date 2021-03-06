defmodule MyHiveWeb.Plugs.ForceSignOut do
  import Plug.Conn
  import Phoenix.Controller
  alias MyHive.Accounts
  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = conn.assigns.current_user
    if current_user && current_user.force_sign_out do
      Accounts.disable_mark_for_sign_out(current_user)
      conn
        |> delete_session(:current_user_id)
        |> delete_session(:current_user)
        |> delete_session(:jwt)
        |> put_flash(:info, "Your session has expired")
        |> redirect(to: MyHiveWeb.Router.Helpers.session_path(conn, :new))
        |> halt()
    else
      conn
    end
  end

end
