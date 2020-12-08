defmodule MyHiveWeb.Api.V1.SettingsController do
  use MyHiveWeb, :controller
  action_fallback MyHiveWeb.FallbackController
  alias MyHive.Saas
  alias MyHive.Oauth2

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    provider = Oauth2.find_by_name("Microsoft")
    conn |> json(%{
      settings: current_user.settings,
      microsoft: Oauth2.authenticated?(current_user.id, provider.id)})
  end

  def modules(conn, %{"account_id" => account_id}) do
    modules = account_id |> Saas.get_active_modules_for()
    conn |> render("modules.json", modules: modules)
  end

end
