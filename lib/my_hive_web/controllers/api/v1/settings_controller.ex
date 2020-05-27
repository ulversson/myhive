defmodule MyHiveWeb.Api.V1.SettingsController do
  use MyHiveWeb, :controller
  action_fallback MyHiveWeb.FallbackController
  alias MyHive.Saas
  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    conn |> json(%{settings: current_user.settings})
  end

  def modules(conn, %{"account_id" => account_id}) do
    modules = account_id |> Saas.get_active_modules_for()
    conn |> render("modules.json", modules: modules)
  end

end
