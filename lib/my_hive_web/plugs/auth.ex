defmodule MyHiveWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias MyHive.Accounts
  alias MyHive.Repo

  def init(opts), do: opts

  def call(conn, _opts) do
    if user_id = Plug.Conn.get_session(conn, :current_user_id) do
      current_user = Accounts.get_user!(user_id) |> Repo.preload(:saas_accounts)
      conn = Plug.Conn.put_session(conn, :account_id, first_account(current_user))
      conn |> assign(:current_user, current_user)
    else
      conn
        |> redirect(to: "/login")
        |> halt()
    end
  end

  defp first_account(user) do
    account = user.saas_accounts |> List.first
    if account do
      account.id
    else
      nil
    end
  end

end
